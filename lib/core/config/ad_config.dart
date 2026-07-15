import 'package:flutter/foundation.dart';

import '../services/ad_environment_gateway.dart';

class AdConfig {
  AdConfig._();

  static const String _iosTestBannerAdUnitId =
      'ca-app-pub-3940256099942544/2934735716';
  static const String _iosProductionBannerAdUnitId =
      'ca-app-pub-8811650450958094/5035306031';

  static String? bannerAdUnitId({
    required TargetPlatform platform,
    required bool isDebug,
    required AdStoreEnvironment environment,
  }) {
    if (platform != TargetPlatform.iOS) return null;

    if (isDebug || environment == AdStoreEnvironment.sandbox) {
      return _iosTestBannerAdUnitId;
    }

    return environment == AdStoreEnvironment.production
        ? _iosProductionBannerAdUnitId
        : null;
  }
}
