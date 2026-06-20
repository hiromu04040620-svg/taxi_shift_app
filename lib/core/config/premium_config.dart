class PremiumConfig {
  PremiumConfig._();

  /// 初回審査では広告とアプリ内課金の導線を審査対象から外す。
  static const bool monetizationEnabled = false;

  static const String removeAdsProductId = 'remove_ads';
  static const Set<String> removeAdsProductIds = {removeAdsProductId};
  static const String fallbackPriceLabel = '300円';
}
