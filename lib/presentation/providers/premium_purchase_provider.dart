import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../application/providers/app_settings_controller.dart';
import '../../core/config/premium_config.dart';

final premiumPurchaseControllerProvider =
    ChangeNotifierProvider<PremiumPurchaseController>(
      (ref) => PremiumPurchaseController(ref),
    );

class PremiumPurchaseController extends ChangeNotifier {
  PremiumPurchaseController(this._ref, {InAppPurchase? inAppPurchase})
    : _iap = inAppPurchase ?? InAppPurchase.instance {
    _subscription = _iap.purchaseStream.listen(
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
  final InAppPurchase _iap;
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
      _isStoreAvailable = await _iap.isAvailable();
      if (!_isStoreAvailable) {
        _message = 'ストアに接続できません';
        return;
      }

      final response = await _iap.queryProductDetails({
        PremiumConfig.removeAdsProductId,
      });
      if (response.error != null) {
        _message = '商品情報の取得に失敗しました';
        return;
      }
      if (response.notFoundIDs.contains(PremiumConfig.removeAdsProductId)) {
        _message = '広告非表示の商品がまだストアに登録されていません';
        return;
      }

      _removeAdsProduct = response.productDetails.firstWhere(
        (product) => product.id == PremiumConfig.removeAdsProductId,
      );
    } catch (_) {
      _message = '商品情報の取得に失敗しました';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

    final started = await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
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
      await _iap.restorePurchases();
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
      if (purchase.productID != PremiumConfig.removeAdsProductId) {
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
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

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
