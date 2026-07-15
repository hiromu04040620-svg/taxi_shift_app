import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

typedef AdaptiveBannerSizeResolver = Future<AdSize?> Function(int width);
typedef BannerAdFactory =
    BannerAd Function({
      required String adUnitId,
      required AdSize size,
      required BannerAdListener listener,
    });

abstract interface class LoadedBannerAd {
  int get width;

  int get height;

  Widget get view;

  Future<void> dispose();
}

abstract interface class BannerAdLoader {
  Future<LoadedBannerAd?> load({required String adUnitId, required int width});
}

class GoogleBannerAdLoader implements BannerAdLoader {
  final AdaptiveBannerSizeResolver _sizeResolver;
  final BannerAdFactory _adFactory;

  GoogleBannerAdLoader({
    AdaptiveBannerSizeResolver? sizeResolver,
    BannerAdFactory? adFactory,
  }) : _sizeResolver =
           sizeResolver ?? AdSize.getLargeAnchoredAdaptiveBannerAdSize,
       _adFactory = adFactory ?? _createBannerAd;

  @override
  Future<LoadedBannerAd?> load({
    required String adUnitId,
    required int width,
  }) async {
    if (width <= 0) return null;

    final size = await _sizeResolver(width);
    if (size == null) return null;

    final completer = Completer<LoadedBannerAd?>();
    late final BannerAd bannerAd;
    bannerAd = _adFactory(
      adUnitId: adUnitId,
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!completer.isCompleted) {
            completer.complete(_GoogleLoadedBannerAd(bannerAd));
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed (${error.code}): ${error.message}');
          unawaited(ad.dispose());
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    try {
      await bannerAd.load();
      return await completer.future;
    } catch (error, stackTrace) {
      debugPrint('Banner ad load failed: $error\n$stackTrace');
      await bannerAd.dispose();
      return null;
    }
  }

  static BannerAd _createBannerAd({
    required String adUnitId,
    required AdSize size,
    required BannerAdListener listener,
  }) {
    return BannerAd(
      adUnitId: adUnitId,
      size: size,
      listener: listener,
      request: const AdRequest(),
    );
  }
}

class _GoogleLoadedBannerAd implements LoadedBannerAd {
  final BannerAd _ad;

  @override
  final Widget view;

  _GoogleLoadedBannerAd(BannerAd ad) : _ad = ad, view = AdWidget(ad: ad);

  @override
  int get height => _ad.size.height;

  @override
  int get width => _ad.size.width;

  @override
  Future<void> dispose() => _ad.dispose();
}
