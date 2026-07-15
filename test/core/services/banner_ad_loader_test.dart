import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:taxi_shift_app/core/services/banner_ad_loader.dart';

class _FakeBannerAd extends BannerAd {
  bool disposed = false;

  _FakeBannerAd({
    required super.size,
    required super.adUnitId,
    required super.listener,
  }) : super(request: const AdRequest());

  @override
  Future<void> load() async {
    listener.onAdLoaded?.call(this);
  }

  @override
  Future<void> dispose() async {
    disposed = true;
  }
}

void main() {
  test('画面幅に合うアダプティブ広告を読み込む', () async {
    int? requestedWidth;
    String? requestedAdUnitId;
    _FakeBannerAd? createdAd;
    final loader = GoogleBannerAdLoader(
      sizeResolver: (width) async {
        requestedWidth = width;
        return const AdSize(width: 390, height: 60);
      },
      adFactory: ({required adUnitId, required listener, required size}) {
        requestedAdUnitId = adUnitId;
        return createdAd = _FakeBannerAd(
          size: size,
          adUnitId: adUnitId,
          listener: listener,
        );
      },
    );

    final loaded = await loader.load(adUnitId: 'test-banner', width: 390);

    expect(requestedWidth, 390);
    expect(requestedAdUnitId, 'test-banner');
    expect(loaded, isNotNull);
    expect(loaded!.width, 390);
    expect(loaded.height, 60);

    await loaded.dispose();
    expect(createdAd!.disposed, true);
  });

  test('端末に適合するサイズを取得できなければ広告を要求しない', () async {
    var factoryCalled = false;
    final loader = GoogleBannerAdLoader(
      sizeResolver: (_) async => null,
      adFactory: ({required adUnitId, required listener, required size}) {
        factoryCalled = true;
        return _FakeBannerAd(
          size: size,
          adUnitId: adUnitId,
          listener: listener,
        );
      },
    );

    final loaded = await loader.load(adUnitId: 'test-banner', width: 390);

    expect(loaded, isNull);
    expect(factoryCalled, false);
  });
}
