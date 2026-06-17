import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:taxi_shift_app/core/config/premium_config.dart';
import 'package:taxi_shift_app/presentation/providers/premium_purchase_provider.dart';

void main() {
  test('商品情報の取得時に広告非表示の商品ID候補を問い合わせる', () async {
    final store = FakePremiumStore(
      response: ProductDetailsResponse(
        productDetails: [productDetails(PremiumConfig.removeAdsProductId)],
        notFoundIDs: [],
      ),
    );
    final container = ProviderContainer(
      overrides: [premiumStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    addTearDown(store.dispose);

    final controller = container.read(premiumPurchaseControllerProvider);
    await waitForIdle(controller);

    expect(store.queriedIds, containsAll(PremiumConfig.removeAdsProductIds));
    expect(
      store.queriedIds,
      hasLength(PremiumConfig.removeAdsProductIds.length),
    );
    expect(controller.canPurchase, isTrue);
    expect(controller.priceLabel, '¥300');
    expect(controller.message, isNull);
  });

  test('App Store Connect と同じ remove_ads のみを問い合わせる', () async {
    final store = FakePremiumStore(
      response: ProductDetailsResponse(
        productDetails: [productDetails(PremiumConfig.removeAdsProductId)],
        notFoundIDs: [],
      ),
    );
    final container = ProviderContainer(
      overrides: [premiumStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    addTearDown(store.dispose);

    final controller = container.read(premiumPurchaseControllerProvider);
    await waitForIdle(controller);

    expect(controller.canPurchase, isTrue);
    expect(store.queriedIds, {PremiumConfig.removeAdsProductId});
    expect(controller.removeAdsProduct?.id, PremiumConfig.removeAdsProductId);
  });

  test('商品が見つからない場合はストア設定確認メッセージを表示する', () async {
    final store = FakePremiumStore(
      response: ProductDetailsResponse(
        productDetails: [],
        notFoundIDs: PremiumConfig.removeAdsProductIds.toList(),
      ),
    );
    final container = ProviderContainer(
      overrides: [premiumStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    addTearDown(store.dispose);

    final controller = container.read(premiumPurchaseControllerProvider);
    await waitForIdle(controller);

    expect(controller.canPurchase, isFalse);
    expect(controller.message, contains('ストア設定'));
  });

  test('購入開始時は取得済みの商品情報を使う', () async {
    final product = productDetails(PremiumConfig.removeAdsProductId);
    final store = FakePremiumStore(
      response: ProductDetailsResponse(
        productDetails: [product],
        notFoundIDs: [],
      ),
    );
    final container = ProviderContainer(
      overrides: [premiumStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    addTearDown(store.dispose);

    final controller = container.read(premiumPurchaseControllerProvider);
    await waitForIdle(controller);

    final message = await controller.buyRemoveAds();

    expect(store.boughtProduct, same(product));
    expect(message, '購入処理を開始しました');
  });
}

ProductDetails productDetails(String id) {
  return ProductDetails(
    id: id,
    title: '広告非表示',
    description: 'カレンダーとサマリーの広告を非表示にします。',
    price: '¥300',
    rawPrice: 300,
    currencyCode: 'JPY',
    currencySymbol: '¥',
  );
}

Future<void> waitForIdle(PremiumPurchaseController controller) async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
    if (!controller.isLoading) return;
  }
  fail('PremiumPurchaseController did not finish loading.');
}

class FakePremiumStore implements PremiumStore {
  FakePremiumStore({required this.response, this.available = true});

  final ProductDetailsResponse response;
  final bool available;
  final _purchaseController =
      StreamController<List<PurchaseDetails>>.broadcast();

  Set<String> queriedIds = {};
  ProductDetails? boughtProduct;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream =>
      _purchaseController.stream;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) {
    queriedIds = identifiers;
    return Future.value(response);
  }

  @override
  Future<bool> buyNonConsumable(ProductDetails product) async {
    boughtProduct = product;
    return true;
  }

  @override
  Future<void> restorePurchases() async {}

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}

  Future<void> dispose() => _purchaseController.close();
}
