class PremiumConfig {
  PremiumConfig._();

  static const String removeAdsProductId = 'remove_ads';
  static const String qualifiedRemoveAdsProductId =
      'com.sasame.takushiftokun.remove_ads';
  static const Set<String> removeAdsProductIds = {
    removeAdsProductId,
    qualifiedRemoveAdsProductId,
  };
  static const String fallbackPriceLabel = '300円';
}
