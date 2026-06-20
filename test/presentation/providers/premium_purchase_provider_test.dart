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

  test('購入開始がfalseを返した場合は復元案内を表示する', () async {
    final product = productDetails(PremiumConfig.removeAdsProductId);
    final store = FakePremiumStore(
      response: ProductDetailsResponse(
        productDetails: [product],
        notFoundIDs: [],
      ),
      buyResult: false,
    );
    final container = ProviderContainer(
      overrides: [premiumStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    addTearDown(store.dispose);

    final controller = container.read(premiumPurchaseControllerProvider);
    await waitForIdle(controller);

    final message = await controller.buyRemoveAds();

    expect(message, contains('購入を復元'));
    expect(controller.isLoading, isFalse);
  });

  test('購入開始時の例外では復元確認を試す', () async {
    final product = productDetails(PremiumConfig.removeAdsProductId);
    final store = FakePremiumStore(
      response: ProductDetailsResponse(
        productDetails: [product],
        notFoundIDs: [],
      ),
      buyError: StateError('storekit failed'),
    );
    final container = ProviderContainer(
      overrides: [premiumStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    addTearDown(store.dispose);

    final controller = container.read(premiumPurchaseControllerProvider);
    await waitForIdle(controller);

    final message = await controller.buyRemoveAds();

    expect(store.restoreCallCount, 1);
    expect(message, contains('復元結果'));
    expect(controller.isLoading, isFalse);
  });

  test('購入ステータスがerrorの場合は復元案内を表示する', () async {
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

    store.emitPurchase(
      purchaseDetails(
        productId: PremiumConfig.removeAdsProductId,
        status: PurchaseStatus.error,
        error: IAPError(
          source: 'storekit',
          code: 'purchase_error',
          message: 'The purchase failed.',
        ),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(store.restoreCallCount, 1);
    expect(controller.message, contains('購入を復元'));
    expect(controller.isLoading, isFalse);
  });

  test('購入復元はストリーム更新がなくても読み込み状態を解除する', () async {
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

    final message = await controller.restorePurchases();

    expect(store.restoreCallCount, 1);
    expect(message, contains('購入情報を確認しました'));
    expect(controller.isLoading, isFalse);
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

PurchaseDetails purchaseDetails({
  required String productId,
  required PurchaseStatus status,
  IAPError? error,
}) {
  final purchase = PurchaseDetails(
    productID: productId,
    verificationData: PurchaseVerificationData(
      localVerificationData: 'local',
      serverVerificationData: 'server',
      source: 'test',
    ),
    transactionDate: null,
    status: status,
  );
  purchase.error = error;
  return purchase;
}

Future<void> waitForIdle(PremiumPurchaseController controller) async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
    if (!controller.isLoading) return;
  }
  fail('PremiumPurchaseController did not finish loading.');
}

class FakePremiumStore implements PremiumStore {
  FakePremiumStore({
    required this.response,
    this.available = true,
    this.buyResult = true,
    this.buyError,
  });

  final ProductDetailsResponse response;
  final bool available;
  final bool buyResult;
  final Object? buyError;
  final _purchaseController =
      StreamController<List<PurchaseDetails>>.broadcast();

  Set<String> queriedIds = {};
  ProductDetails? boughtProduct;
  int restoreCallCount = 0;

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
    final error = buyError;
    if (error != null) throw error;
    return buyResult;
  }

  @override
  Future<void> restorePurchases() async {
    restoreCallCount++;
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}

  void emitPurchase(PurchaseDetails purchase) {
    _purchaseController.add([purchase]);
  }

  Future<void> dispose() => _purchaseController.close();
}
