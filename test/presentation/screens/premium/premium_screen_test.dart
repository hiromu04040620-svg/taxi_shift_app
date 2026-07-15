import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:taxi_shift_app/core/config/premium_config.dart';
import 'package:taxi_shift_app/core/services/in_app_purchase_gateway.dart';
import 'package:taxi_shift_app/domain/models/app_settings.dart';
import 'package:taxi_shift_app/presentation/providers/app_settings_queries_provider.dart';
import 'package:taxi_shift_app/presentation/screens/premium/premium_screen.dart';

class PremiumScreenGateway implements InAppPurchaseGateway {
  final controller = StreamController<List<PurchaseDetails>>.broadcast();
  var response = ProductDetailsResponse(
    productDetails: [
      ProductDetails(
        id: PremiumConfig.removeAdsProductId,
        title: '広告非表示',
        description: '案内枠を非表示にします。',
        price: '¥300',
        rawPrice: 300,
        currencyCode: 'JPY',
        currencySymbol: '¥',
      ),
    ],
    notFoundIDs: const [],
  );
  int buyCount = 0;
  int restoreCount = 0;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => controller.stream;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProductDetails(
    Set<String> productIds,
  ) async => response;

  @override
  Future<bool> buyNonConsumable(ProductDetails product) async {
    buyCount += 1;
    return true;
  }

  @override
  Future<void> restorePurchases() async {
    restoreCount += 1;
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}

  Future<void> dispose() => controller.close();
}

const freeSettings = AppSettings(
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

void main() {
  late PremiumScreenGateway gateway;

  setUp(() {
    gateway = PremiumScreenGateway();
    addTearDown(gateway.dispose);
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    AppSettings settings = freeSettings,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inAppPurchaseGatewayProvider.overrideWithValue(gateway),
          appSettingsProvider.overrideWithValue(AsyncData(settings)),
        ],
        child: const MaterialApp(home: PremiumScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('価格、買い切り、購入、復元を一画面で確認できる', (tester) async {
    await pumpScreen(tester);

    expect(find.text('広告非表示'), findsWidgets);
    expect(find.textContaining('¥300'), findsOneWidget);
    expect(find.text('¥300・買い切り'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '広告非表示を購入'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, '購入を復元'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, '広告非表示を購入'));
    await tester.pump();
    expect(gateway.buyCount, 1);
  });

  testWidgets('商品を取得できない場合は理由と再読み込みを表示する', (tester) async {
    gateway.response = ProductDetailsResponse(
      productDetails: const [],
      notFoundIDs: const [PremiumConfig.removeAdsProductId],
    );

    await pumpScreen(tester);

    expect(find.textContaining('商品情報を取得できませんでした'), findsOneWidget);
    expect(find.widgetWithText(TextButton, '購入情報を再読み込み'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '購入情報を確認中'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('購入済みでは有効状態を表示して購入ボタンを隠す', (tester) async {
    await pumpScreen(tester, settings: freeSettings.copyWith(isPremium: true));

    expect(find.text('広告非表示は有効です'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '広告非表示を購入'), findsNothing);
    expect(find.widgetWithText(OutlinedButton, '購入を復元'), findsOneWidget);
  });

  testWidgets('購入失敗時は技術文言ではなく再試行案内と診断コードを表示する', (tester) async {
    await pumpScreen(tester);

    final details =
        PurchaseDetails(
            purchaseID: 'purchase-error',
            productID: PremiumConfig.removeAdsProductId,
            verificationData: PurchaseVerificationData(
              localVerificationData: 'local',
              serverVerificationData: 'server',
              source: 'app_store',
            ),
            transactionDate: null,
            status: PurchaseStatus.error,
          )
          ..error = IAPError(
            source: 'app_store',
            code: 'storekit_unknown',
            message: 'SKErrorDomain',
          );
    gateway.controller.add([details]);
    await tester.pumpAndSettle();

    expect(find.textContaining('購入を完了できませんでした'), findsOneWidget);
    expect(find.text('エラーコード: app_store/storekit_unknown'), findsOneWidget);
    expect(find.text('SKErrorDomain'), findsNothing);
  });
}
