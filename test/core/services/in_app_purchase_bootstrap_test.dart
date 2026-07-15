import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/core/services/in_app_purchase_bootstrap.dart';

void main() {
  test('iOS では StoreKit 1 を有効化する', () async {
    var called = false;

    await configureInAppPurchasePlatform(
      platform: TargetPlatform.iOS,
      enableStoreKit1: () async {
        called = true;
        return false;
      },
    );

    expect(called, true);
  });

  test('iOS 以外では StoreKit 設定を変更しない', () async {
    var called = false;

    await configureInAppPurchasePlatform(
      platform: TargetPlatform.android,
      enableStoreKit1: () async {
        called = true;
        return false;
      },
    );

    expect(called, false);
  });
}
