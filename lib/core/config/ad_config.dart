import 'dart:io';
import 'package:flutter/foundation.dart';

class AdConfig {
  AdConfig._();

  static String get bannerAdUnitId {
    if (kDebugMode) {
      // Google 公式テスト ID
      return Platform.isIOS
          ? 'ca-app-pub-3940256099942544/2934735716'
          : 'ca-app-pub-3940256099942544/6300978111';
    }
    // 本番
    if (Platform.isIOS) {
      return 'ca-app-pub-8811650450958094/5035306031';
    }
    throw UnsupportedError('Android is not supported yet');
  }
}
