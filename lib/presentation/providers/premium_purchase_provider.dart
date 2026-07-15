import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../application/providers/repositories_provider.dart';
import '../../core/config/premium_config.dart';
import '../../core/services/in_app_purchase_gateway.dart';

enum PremiumPurchaseStatus {
  loading,
  ready,
  purchasing,
  restoring,
  purchased,
  unavailable,
  error,
}

class PremiumPurchaseState {
  final PremiumPurchaseStatus status;
  final ProductDetails? product;
  final String? message;
  final String? errorCode;

  const PremiumPurchaseState({
    required this.status,
    this.product,
    this.message,
    this.errorCode,
  });

  const PremiumPurchaseState.loading()
    : status = PremiumPurchaseStatus.loading,
      product = null,
      message = null,
      errorCode = null;

  bool get canPurchase =>
      status == PremiumPurchaseStatus.ready && product != null;
}

final premiumPurchaseControllerProvider =
    NotifierProvider<PremiumPurchaseController, PremiumPurchaseState>(
      PremiumPurchaseController.new,
    );

class PremiumPurchaseController extends Notifier<PremiumPurchaseState> {
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  late InAppPurchaseGateway _gateway;
  var _disposed = false;

  @override
  PremiumPurchaseState build() {
    _gateway = ref.watch(inAppPurchaseGatewayProvider);
    _purchaseSubscription = _gateway.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: _handlePurchaseStreamError,
    );
    ref.onDispose(() {
      _disposed = true;
      unawaited(_purchaseSubscription?.cancel());
    });
    unawaited(Future<void>.microtask(reload));
    return const PremiumPurchaseState.loading();
  }

  Future<void> reload() async {
    state = const PremiumPurchaseState.loading();

    try {
      final available = await _gateway.isAvailable();
      if (_disposed) return;

      if (!available) {
        state = const PremiumPurchaseState(
          status: PremiumPurchaseStatus.unavailable,
          message: 'App Store に接続できませんでした。通信状態を確認してください。',
        );
        return;
      }

      final response = await _gateway.queryProductDetails({
        PremiumConfig.removeAdsProductId,
      });
      if (_disposed) return;

      final queryError = response.error;
      if (queryError != null) {
        _logIapError('query-product', queryError);
      }

      final product = response.productDetails
          .where((item) => item.id == PremiumConfig.removeAdsProductId)
          .firstOrNull;
      if (product == null) {
        state = PremiumPurchaseState(
          status: PremiumPurchaseStatus.error,
          message: '広告非表示の商品情報を取得できませんでした。時間をおいて再度お試しください。',
          errorCode: queryError == null
              ? 'app_store/product-not-found'
              : _iapDiagnosticCode(queryError),
        );
        return;
      }

      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.ready,
        product: product,
      );
    } catch (error, stackTrace) {
      _logUnexpectedError('query-product', error, stackTrace);
      if (_disposed) return;
      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.error,
        message: '購入情報の読み込みに失敗しました。時間をおいて再度お試しください。',
        errorCode: _unexpectedDiagnosticCode(error),
      );
    }
  }

  Future<void> purchase() async {
    final product = state.product;
    if (!PremiumConfig.monetizationEnabled ||
        !state.canPurchase ||
        product == null) {
      return;
    }

    state = PremiumPurchaseState(
      status: PremiumPurchaseStatus.purchasing,
      product: product,
    );

    try {
      final started = await _gateway.buyNonConsumable(product);
      if (_disposed) return;
      if (!started) {
        state = PremiumPurchaseState(
          status: PremiumPurchaseStatus.ready,
          product: product,
          message: '購入を開始できませんでした。もう一度お試しください。',
          errorCode: 'purchase/not-started',
        );
      }
    } catch (error, stackTrace) {
      _logUnexpectedError('start-purchase', error, stackTrace);
      if (_disposed) return;
      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.ready,
        product: product,
        message: '購入を開始できませんでした。もう一度お試しください。',
        errorCode: _unexpectedDiagnosticCode(error),
      );
    }
  }

  Future<void> restore() async {
    if (state.status == PremiumPurchaseStatus.purchasing ||
        state.status == PremiumPurchaseStatus.restoring) {
      return;
    }

    final product = state.product;
    state = PremiumPurchaseState(
      status: PremiumPurchaseStatus.restoring,
      product: product,
    );

    try {
      await _gateway.restorePurchases();
      if (_disposed || state.status != PremiumPurchaseStatus.restoring) return;
      state = PremiumPurchaseState(
        status: product == null
            ? PremiumPurchaseStatus.error
            : PremiumPurchaseStatus.ready,
        product: product,
        message: '購入履歴を確認しています。復元結果が反映されるまでお待ちください。',
      );
    } catch (error, stackTrace) {
      _logUnexpectedError('restore', error, stackTrace);
      if (_disposed) return;
      state = PremiumPurchaseState(
        status: product == null
            ? PremiumPurchaseStatus.error
            : PremiumPurchaseStatus.ready,
        product: product,
        message: '購入の復元に失敗しました。もう一度お試しください。',
        errorCode: _unexpectedDiagnosticCode(error),
      );
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != PremiumConfig.removeAdsProductId) continue;

      switch (purchase.status) {
        case PurchaseStatus.pending:
          state = PremiumPurchaseState(
            status: PremiumPurchaseStatus.purchasing,
            product: state.product,
            message: 'App Store で購入を確認しています。',
          );
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _activatePremium(purchase);
        case PurchaseStatus.error:
          final purchaseError = purchase.error;
          if (purchaseError != null) {
            _logIapError('purchase-update', purchaseError);
          }
          state = PremiumPurchaseState(
            status: state.product == null
                ? PremiumPurchaseStatus.error
                : PremiumPurchaseStatus.ready,
            product: state.product,
            message: '購入を完了できませんでした。もう一度お試しください。',
            errorCode: purchaseError == null
                ? 'app_store/unknown'
                : _iapDiagnosticCode(purchaseError),
          );
        case PurchaseStatus.canceled:
          state = PremiumPurchaseState(
            status: state.product == null
                ? PremiumPurchaseStatus.error
                : PremiumPurchaseStatus.ready,
            product: state.product,
            message: '購入はキャンセルされました。',
          );
      }
    }
  }

  Future<void> _activatePremium(PurchaseDetails purchase) async {
    try {
      await ref.read(appSettingsRepositoryProvider).updatePremiumStatus(true);
      if (purchase.pendingCompletePurchase) {
        await _gateway.completePurchase(purchase);
      }
      if (_disposed) return;
      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.purchased,
        product: state.product,
        message: '広告非表示が有効になりました。',
      );
    } catch (error, stackTrace) {
      _logUnexpectedError('activate-premium', error, stackTrace);
      if (_disposed) return;
      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.error,
        product: state.product,
        message: '購入内容をアプリに反映できませんでした。購入を復元してください。',
        errorCode: _unexpectedDiagnosticCode(error),
      );
    }
  }

  void _handlePurchaseStreamError(Object error, StackTrace stackTrace) {
    _logUnexpectedError('purchase-stream', error, stackTrace);
    if (_disposed) return;
    state = PremiumPurchaseState(
      status: state.product == null
          ? PremiumPurchaseStatus.error
          : PremiumPurchaseStatus.ready,
      product: state.product,
      message: '購入状態を確認できませんでした。もう一度お試しください。',
      errorCode: _unexpectedDiagnosticCode(error),
    );
  }

  String _iapDiagnosticCode(IAPError error) {
    return '${error.source}/${error.code}';
  }

  String _unexpectedDiagnosticCode(Object error) {
    if (error is IAPError) return _iapDiagnosticCode(error);
    if (error is PlatformException) return 'platform/${error.code}';
    return 'purchase/${error.runtimeType}';
  }

  void _logIapError(String operation, IAPError error) {
    debugPrint(
      'IAP error operation=$operation source=${error.source} '
      'code=${error.code} message=${error.message} details=${error.details}',
    );
  }

  void _logUnexpectedError(
    String operation,
    Object error,
    StackTrace stackTrace,
  ) {
    if (error is IAPError) {
      _logIapError(operation, error);
      return;
    }
    debugPrint('IAP error operation=$operation error=$error\n$stackTrace');
  }
}
