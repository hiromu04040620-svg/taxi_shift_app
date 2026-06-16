import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../application/providers/app_settings_controller.dart';
import '../../core/config/premium_config.dart';

final premiumStoreProvider = Provider<PremiumStore>(
  (ref) => InAppPurchasePremiumStore(InAppPurchase.instance),
);

final premiumPurchaseControllerProvider =
    ChangeNotifierProvider<PremiumPurchaseController>(
      (ref) => PremiumPurchaseController(
        ref,
        store: ref.watch(premiumStoreProvider),
      ),
    );

abstract class PremiumStore {
  Stream<List<PurchaseDetails>> get purchaseStream;

  Future<bool> isAvailable();

  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers);

  Future<bool> buyNonConsumable(ProductDetails product);

  Future<void> restorePurchases();

  Future<void> completePurchase(PurchaseDetails purchase);
}

class InAppPurchasePremiumStore implements PremiumStore {
  InAppPurchasePremiumStore(this._iap);

  final InAppPurchase _iap;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) =>
      _iap.queryProductDetails(identifiers);

  @override
  Future<bool> buyNonConsumable(ProductDetails product) {
    return _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
  }

  @override
  Future<void> restorePurchases() => _iap.restorePurchases();

  @override
  Future<void> completePurchase(PurchaseDetails purchase) {
    return _iap.completePurchase(purchase);
  }
}

class PremiumPurchaseController extends ChangeNotifier {
  PremiumPurchaseController(this._ref, {required this._store}) {
    _subscription = _store.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        _isLoading = false;
        _message = '購入状態の取得に失敗しました';
        notifyListeners();
      },
    );
    loadProducts();
  }

  final Ref _ref;
  final PremiumStore _store;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isLoading = false;
  bool _isStoreAvailable = false;
  String? _message;
  ProductDetails? _removeAdsProduct;

  bool get isLoading => _isLoading;
  bool get isStoreAvailable => _isStoreAvailable;
  String? get message => _message;
  ProductDetails? get removeAdsProduct => _removeAdsProduct;

  String get priceLabel =>
      _removeAdsProduct?.price ?? PremiumConfig.fallbackPriceLabel;

  bool get canPurchase =>
      !_isLoading && _isStoreAvailable && _removeAdsProduct != null;

  Future<void> loadProducts() async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      _isStoreAvailable = await _store.isAvailable();
      if (!_isStoreAvailable) {
        _removeAdsProduct = null;
        _message = 'ストアに接続できません';
        return;
      }

      final response = await _store.queryProductDetails(
        PremiumConfig.removeAdsProductIds,
      );
      final product = _findRemoveAdsProduct(response.productDetails);
      if (product != null) {
        _removeAdsProduct = product;
        return;
      }

      _removeAdsProduct = null;
      if (response.error != null) {
        debugPrint('Remove ads product query failed: ${response.error}');
        _message = '商品情報の取得に失敗しました。時間をおいて再取得してください';
        return;
      }

      final notFoundIds = response.notFoundIDs.toSet();
      if (PremiumConfig.removeAdsProductIds.every(notFoundIds.contains) ||
          response.productDetails.isEmpty) {
        _message = '広告非表示の商品を取得できません。ストア設定を確認してください';
        return;
      }

      _message = '広告非表示の商品情報が見つかりません';
    } catch (error, stackTrace) {
      debugPrint('Remove ads product query failed: $error\n$stackTrace');
      _removeAdsProduct = null;
      _message = '商品情報の取得に失敗しました。時間をおいて再取得してください';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ProductDetails? _findRemoveAdsProduct(List<ProductDetails> products) {
    for (final id in PremiumConfig.removeAdsProductIds) {
      for (final product in products) {
        if (product.id == id) return product;
      }
    }
    return null;
  }

  Future<String?> buyRemoveAds() async {
    if (_isLoading) return null;
    if (_removeAdsProduct == null) {
      await loadProducts();
    }
    final product = _removeAdsProduct;
    if (!_isStoreAvailable || product == null) {
      return _message ?? '商品情報を取得できません';
    }

    _isLoading = true;
    _message = null;
    notifyListeners();

    final started = await _store.buyNonConsumable(product);
    if (!started) {
      _isLoading = false;
      _message = '購入処理を開始できませんでした';
      notifyListeners();
      return _message;
    }
    return '購入処理を開始しました';
  }

  Future<String?> restorePurchases() async {
    if (_isLoading) return null;

    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      await _store.restorePurchases();
      _message = '購入情報を確認しています';
      return _message;
    } catch (_) {
      _isLoading = false;
      _message = '購入の復元に失敗しました';
      notifyListeners();
      return _message;
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (!PremiumConfig.removeAdsProductIds.contains(purchase.productID)) {
        await _completePurchaseIfNeeded(purchase);
        continue;
      }

      switch (purchase.status) {
        case PurchaseStatus.pending:
          _isLoading = true;
          _message = '購入処理を確認しています';
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _ref
              .read(appSettingsControllerProvider.notifier)
              .updatePremiumStatus(true);
          _isLoading = false;
          _message = '広告非表示が有効になりました';
          break;
        case PurchaseStatus.error:
          _isLoading = false;
          _message = purchase.error?.message ?? '購入処理に失敗しました';
          break;
        case PurchaseStatus.canceled:
          _isLoading = false;
          _message = '購入をキャンセルしました';
          break;
      }

      await _completePurchaseIfNeeded(purchase);
    }
    notifyListeners();
  }

  Future<void> _completePurchaseIfNeeded(PurchaseDetails purchase) async {
    if (!purchase.pendingCompletePurchase) return;

    try {
      await _store.completePurchase(purchase);
    } catch (error, stackTrace) {
      debugPrint('Failed to complete purchase: $error\n$stackTrace');
    }
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
