import 'dart:async';

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

  const PremiumPurchaseState({
    required this.status,
    this.product,
    this.message,
  });

  const PremiumPurchaseState.loading()
    : status = PremiumPurchaseStatus.loading,
      product = null,
      message = null;

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

      final product = response.productDetails
          .where((item) => item.id == PremiumConfig.removeAdsProductId)
          .firstOrNull;
      if (product == null) {
        state = const PremiumPurchaseState(
          status: PremiumPurchaseStatus.error,
          message: '広告非表示の商品情報を取得できませんでした。時間をおいて再度お試しください。',
        );
        return;
      }

      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.ready,
        product: product,
      );
    } catch (_) {
      if (_disposed) return;
      state = const PremiumPurchaseState(
        status: PremiumPurchaseStatus.error,
        message: '購入情報の読み込みに失敗しました。時間をおいて再度お試しください。',
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
        );
      }
    } catch (_) {
      if (_disposed) return;
      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.ready,
        product: product,
        message: '購入を開始できませんでした。もう一度お試しください。',
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
    } catch (_) {
      if (_disposed) return;
      state = PremiumPurchaseState(
        status: product == null
            ? PremiumPurchaseStatus.error
            : PremiumPurchaseStatus.ready,
        product: product,
        message: '購入の復元に失敗しました。もう一度お試しください。',
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
          state = PremiumPurchaseState(
            status: state.product == null
                ? PremiumPurchaseStatus.error
                : PremiumPurchaseStatus.ready,
            product: state.product,
            message: purchase.error?.message ?? '購入に失敗しました。もう一度お試しください。',
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
    } catch (_) {
      if (_disposed) return;
      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.error,
        product: state.product,
        message: '購入内容をアプリに反映できませんでした。購入を復元してください。',
      );
    }
  }

  void _handlePurchaseStreamError(Object _) {
    if (_disposed) return;
    state = PremiumPurchaseState(
      status: state.product == null
          ? PremiumPurchaseStatus.error
          : PremiumPurchaseStatus.ready,
      product: state.product,
      message: '購入状態を確認できませんでした。もう一度お試しください。',
    );
  }
}
