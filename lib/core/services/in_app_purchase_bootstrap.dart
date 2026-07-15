import 'package:flutter/foundation.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

typedef StoreKit1Enabler = Future<bool> Function();

Future<bool> _enableStoreKit1() {
  // StoreKit 2 currently fails to return the first-review product in the review
  // sandbox, so keep the purchase path on the older StoreKit request flow.
  // ignore: deprecated_member_use
  return InAppPurchaseStoreKitPlatform.enableStoreKit1();
}

Future<void> configureInAppPurchasePlatform({
  TargetPlatform? platform,
  StoreKit1Enabler enableStoreKit1 = _enableStoreKit1,
}) async {
  final currentPlatform = platform ?? defaultTargetPlatform;

  if (currentPlatform == TargetPlatform.iOS) {
    await enableStoreKit1();
  }
}
