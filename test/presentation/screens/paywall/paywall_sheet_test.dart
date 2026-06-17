import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:taxi_shift_app/domain/models/app_settings.dart';
import 'package:taxi_shift_app/presentation/providers/app_settings_queries_provider.dart';
import 'package:taxi_shift_app/presentation/providers/premium_purchase_provider.dart';
import 'package:taxi_shift_app/presentation/screens/paywall/paywall_sheet.dart';

void main() {
  testWidgets('商品情報を取得できない場合でも購入ボタンは無効化しない', (tester) async {
    final store = EmptyPremiumStore();
    addTearDown(store.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWithValue(const AsyncData(freeSettings)),
          premiumStoreProvider.overrideWithValue(store),
        ],
        child: const MaterialApp(home: Scaffold(body: PaywallSheet())),
      ),
    );

    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '購入して広告を非表示'),
    );
    expect(button.onPressed, isNotNull);
  });
}

const freeSettings = AppSettings(
  monthlyClosingDay: 15,
  ashikiriAmount: 0,
  commissionRate: 0.5,
  improvementStandardEnabled: true,
  maxMonthlyRestraintHours: 262,
  maxMonthlyShifts: 13,
  themeMode: ThemeMode.system,
  isPremium: false,
  customLabels: {},
);

class EmptyPremiumStore implements PremiumStore {
  final _purchaseController =
      StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream =>
      _purchaseController.stream;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) {
    return Future.value(
      ProductDetailsResponse(
        productDetails: [],
        notFoundIDs: identifiers.toList(),
      ),
    );
  }

  @override
  Future<bool> buyNonConsumable(ProductDetails product) async => true;

  @override
  Future<void> restorePurchases() async {}

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}

  Future<void> dispose() => _purchaseController.close();
}
