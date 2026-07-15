import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/core/config/ad_config.dart';
import 'package:taxi_shift_app/core/services/ad_environment_gateway.dart';

void main() {
  test('iOS SandboxはGoogle公式テストIDを返す', () {
    expect(
      AdConfig.bannerAdUnitId(
        platform: TargetPlatform.iOS,
        isDebug: false,
        environment: AdStoreEnvironment.sandbox,
      ),
      'ca-app-pub-3940256099942544/2934735716',
    );
  });

  test('iOS Debugは本番レシートでもGoogle公式テストIDを返す', () {
    expect(
      AdConfig.bannerAdUnitId(
        platform: TargetPlatform.iOS,
        isDebug: true,
        environment: AdStoreEnvironment.production,
      ),
      'ca-app-pub-3940256099942544/2934735716',
    );
  });

  test('iOS本番レシートだけTaxiShift本番IDを返す', () {
    expect(
      AdConfig.bannerAdUnitId(
        platform: TargetPlatform.iOS,
        isDebug: false,
        environment: AdStoreEnvironment.production,
      ),
      'ca-app-pub-8811650450958094/5035306031',
    );
  });

  test('未対応環境では広告IDを返さない', () {
    expect(
      AdConfig.bannerAdUnitId(
        platform: TargetPlatform.android,
        isDebug: false,
        environment: AdStoreEnvironment.unsupported,
      ),
      isNull,
    );
  });
}
