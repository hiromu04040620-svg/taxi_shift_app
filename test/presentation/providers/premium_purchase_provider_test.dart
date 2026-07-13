import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:taxi_shift_app/application/providers/repositories_provider.dart';
import 'package:taxi_shift_app/core/config/premium_config.dart';
import 'package:taxi_shift_app/core/services/in_app_purchase_gateway.dart';
import 'package:taxi_shift_app/domain/models/app_settings.dart';
import 'package:taxi_shift_app/domain/repositories/app_settings_repository.dart';
import 'package:taxi_shift_app/presentation/providers/premium_purchase_provider.dart';

class FakeInAppPurchaseGateway implements InAppPurchaseGateway {
  final purchaseController = StreamController<List<PurchaseDetails>>.broadcast(
    sync: true,
  );

  bool available = true;
  ProductDetailsResponse response = ProductDetailsResponse(
    productDetails: [testProduct],
    notFoundIDs: const [],
  );
  bool purchaseStarted = true;
  int queryCount = 0;
  int buyCount = 0;
  int restoreCount = 0;
  final completedPurchases = <PurchaseDetails>[];

  static final testProduct = ProductDetails(
    id: PremiumConfig.removeAdsProductId,
    title: '広告非表示',
    description: '案内枠を非表示にします。',
    price: '¥300',
    rawPrice: 300,
    currencyCode: 'JPY',
    currencySymbol: '¥',
  );

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => purchaseController.stream;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<ProductDetailsResponse> queryProductDetails(
    Set<String> productIds,
  ) async {
    queryCount += 1;
    expect(productIds, {PremiumConfig.removeAdsProductId});
    return response;
  }

  @override
  Future<bool> buyNonConsumable(ProductDetails product) async {
    buyCount += 1;
    expect(product.id, PremiumConfig.removeAdsProductId);
    return purchaseStarted;
  }

  @override
  Future<void> restorePurchases() async {
    restoreCount += 1;
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    completedPurchases.add(purchase);
  }

  Future<void> dispose() => purchaseController.close();
}

class FakeAppSettingsRepository implements AppSettingsRepository {
  var settings = const AppSettings(
    monthlyClosingDay: 20,
    ashikiriAmount: 30000,
    commissionRate: 0.6,
    improvementStandardEnabled: true,
    maxMonthlyRestraintHours: 299,
    maxMonthlyShifts: 12,
    themeMode: ThemeMode.system,
    isPremium: false,
    customLabels: {},
  );
  final settingsController = StreamController<AppSettings>.broadcast();
  int premiumUpdateCount = 0;

  @override
  Future<AppSettings> get() async => settings;

  @override
  Stream<AppSettings> watch() async* {
    yield settings;
    yield* settingsController.stream;
  }

  @override
  Future<void> updatePremiumStatus(bool isPremium) async {
    premiumUpdateCount += 1;
    settings = settings.copyWith(isPremium: isPremium);
    settingsController.add(settings);
  }

  @override
  Future<void> deleteAllUserData() async {}

  @override
  Future<void> updateAshikiriAmount(int amount) async {}

  @override
  Future<void> updateCommissionRate(double rate) async {}

  @override
  Future<void> updateImprovementStandardEnabled(bool enabled) async {}

  @override
  Future<void> updateMaxMonthlyRestraintHours(int hours) async {}

  @override
  Future<void> updateMaxMonthlyShifts(int count) async {}

  @override
  Future<void> updateMonthlyClosingDay(int day) async {}

  @override
  Future<void> updateThemeMode(ThemeMode mode) async {}

  Future<void> dispose() => settingsController.close();
}

PurchaseDetails purchaseDetails({
  required PurchaseStatus status,
  bool pendingCompletePurchase = false,
  String productId = PremiumConfig.removeAdsProductId,
}) {
  final details = PurchaseDetails(
    purchaseID: 'purchase-1',
    productID: productId,
    verificationData: PurchaseVerificationData(
      localVerificationData: 'local',
      serverVerificationData: 'server',
      source: 'app_store',
    ),
    transactionDate: '1',
    status: status,
  );
  details.pendingCompletePurchase = pendingCompletePurchase;
  return details;
}

Future<void> waitForStatus(
  ProviderContainer container,
  PremiumPurchaseStatus expected,
) async {
  for (var index = 0; index < 20; index += 1) {
    if (container.read(premiumPurchaseControllerProvider).status == expected) {
      return;
    }
    await Future<void>.delayed(Duration.zero);
  }
  fail(
    'Expected $expected, got '
    '${container.read(premiumPurchaseControllerProvider).status}',
  );
}

void main() {
  late FakeInAppPurchaseGateway gateway;
  late FakeAppSettingsRepository settingsRepository;
  late ProviderContainer container;

  setUp(() {
    gateway = FakeInAppPurchaseGateway();
    settingsRepository = FakeAppSettingsRepository();
    container = ProviderContainer(
      overrides: [
        inAppPurchaseGatewayProvider.overrideWithValue(gateway),
        appSettingsRepositoryProvider.overrideWithValue(settingsRepository),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(gateway.dispose);
    addTearDown(settingsRepository.dispose);
  });

  test('起動後に remove_ads の商品と価格を取得する', () async {
    container.listen(
      premiumPurchaseControllerProvider,
      (_, _) {},
      fireImmediately: true,
    );

    await waitForStatus(container, PremiumPurchaseStatus.ready);

    final state = container.read(premiumPurchaseControllerProvider);
    expect(state.product?.id, PremiumConfig.removeAdsProductId);
    expect(state.product?.price, '¥300');
    expect(state.canPurchase, true);
    expect(gateway.queryCount, 1);
  });

  test('App Store が利用できない場合は理由と再読込可能状態を返す', () async {
    gateway.available = false;
    container.listen(
      premiumPurchaseControllerProvider,
      (_, _) {},
      fireImmediately: true,
    );

    await waitForStatus(container, PremiumPurchaseStatus.unavailable);

    final state = container.read(premiumPurchaseControllerProvider);
    expect(state.message, contains('App Store'));
    expect(state.canPurchase, false);
    expect(gateway.queryCount, 0);
  });

  test('商品IDが見つからない場合は購入を開始しない', () async {
    gateway.response = ProductDetailsResponse(
      productDetails: const [],
      notFoundIDs: const [PremiumConfig.removeAdsProductId],
    );
    container.listen(
      premiumPurchaseControllerProvider,
      (_, _) {},
      fireImmediately: true,
    );

    await waitForStatus(container, PremiumPurchaseStatus.error);
    await container.read(premiumPurchaseControllerProvider.notifier).purchase();

    expect(gateway.buyCount, 0);
    expect(
      container.read(premiumPurchaseControllerProvider).message,
      contains('商品情報'),
    );
  });

  test('購入成功時は権利を保存して未完了取引を完了する', () async {
    container.listen(
      premiumPurchaseControllerProvider,
      (_, _) {},
      fireImmediately: true,
    );
    await waitForStatus(container, PremiumPurchaseStatus.ready);

    await container.read(premiumPurchaseControllerProvider.notifier).purchase();
    expect(gateway.buyCount, 1);
    expect(
      container.read(premiumPurchaseControllerProvider).status,
      PremiumPurchaseStatus.purchasing,
    );

    final details = purchaseDetails(
      status: PurchaseStatus.purchased,
      pendingCompletePurchase: true,
    );
    gateway.purchaseController.add([details]);
    await waitForStatus(container, PremiumPurchaseStatus.purchased);

    expect(settingsRepository.settings.isPremium, true);
    expect(settingsRepository.premiumUpdateCount, 1);
    expect(gateway.completedPurchases, [details]);
  });

  test('キャンセル時は商品を再度購入できる状態へ戻る', () async {
    container.listen(
      premiumPurchaseControllerProvider,
      (_, _) {},
      fireImmediately: true,
    );
    await waitForStatus(container, PremiumPurchaseStatus.ready);
    await container.read(premiumPurchaseControllerProvider.notifier).purchase();

    gateway.purchaseController.add([
      purchaseDetails(status: PurchaseStatus.canceled),
    ]);
    await waitForStatus(container, PremiumPurchaseStatus.ready);

    expect(container.read(premiumPurchaseControllerProvider).canPurchase, true);
    expect(settingsRepository.premiumUpdateCount, 0);
  });

  test('復元はStoreKitへ要求し、対象購入の復元で権利を保存する', () async {
    container.listen(
      premiumPurchaseControllerProvider,
      (_, _) {},
      fireImmediately: true,
    );
    await waitForStatus(container, PremiumPurchaseStatus.ready);

    await container.read(premiumPurchaseControllerProvider.notifier).restore();
    expect(gateway.restoreCount, 1);

    gateway.purchaseController.add([
      purchaseDetails(status: PurchaseStatus.restored),
    ]);
    await waitForStatus(container, PremiumPurchaseStatus.purchased);

    expect(settingsRepository.settings.isPremium, true);
  });
}
