import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/core/services/banner_ad_loader.dart';
import 'package:taxi_shift_app/presentation/widgets/banner_ad_widget.dart';

class _FakeLoadedBannerAd implements LoadedBannerAd {
  final String label;
  bool disposed = false;

  _FakeLoadedBannerAd({this.label = 'Google test ad'});

  @override
  int get height => 50;

  @override
  int get width => 320;

  @override
  Widget get view => Text(label);

  @override
  Future<void> dispose() async {
    disposed = true;
  }
}

class _ResizeBannerAdLoader implements BannerAdLoader {
  final first = _FakeLoadedBannerAd(label: 'first ad');
  final second = _FakeLoadedBannerAd(label: 'second ad');
  final allowSecondLoad = Completer<void>();
  int calls = 0;

  @override
  Future<LoadedBannerAd?> load({
    required String adUnitId,
    required int width,
  }) async {
    calls += 1;
    if (calls == 1) return first;
    await allowSecondLoad.future;
    return second;
  }
}

class _FakeBannerAdLoader implements BannerAdLoader {
  final _FakeLoadedBannerAd loaded = _FakeLoadedBannerAd();
  String? requestedAdUnitId;
  int? requestedWidth;

  @override
  Future<LoadedBannerAd?> load({
    required String adUnitId,
    required int width,
  }) async {
    requestedAdUnitId = adUnitId;
    requestedWidth = width;
    return loaded;
  }
}

void main() {
  test('既定の読み込み役は画面再描画で共有する', () {
    final first = BannerAdWidget(adUnitId: 'test-banner');
    final second = BannerAdWidget(adUnitId: 'test-banner');

    expect(first.loader, same(second.loader));
  });

  testWidgets('読み込んだAdMobバナーだけを指定サイズで表示する', (tester) async {
    final loader = _FakeBannerAdLoader();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BannerAdWidget(
            adUnitId: 'test-banner',
            loader: loader,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(loader.requestedAdUnitId, 'test-banner');
    expect(loader.requestedWidth, isNotNull);
    expect(find.text('Google test ad'), findsOneWidget);
    expect(find.text('広告非表示で画面を広く'), findsNothing);

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pump();
    expect(loader.loaded.disposed, true);
  });

  testWidgets('幅変更時は破棄済みの広告を画面から外してから再読込する', (tester) async {
    final loader = _ResizeBannerAdLoader();

    Widget appWithWidth(double width) {
      return MaterialApp(
        home: Align(
          child: SizedBox(
            width: width,
            child: BannerAdWidget(adUnitId: 'test-banner', loader: loader),
          ),
        ),
      );
    }

    await tester.pumpWidget(appWithWidth(320));
    await tester.pumpAndSettle();
    expect(find.text('first ad'), findsOneWidget);

    await tester.pumpWidget(appWithWidth(390));
    await tester.pump();
    await tester.pump();

    expect(loader.first.disposed, true);
    expect(find.text('first ad'), findsNothing);

    loader.allowSecondLoad.complete();
    await tester.pumpAndSettle();
    expect(find.text('second ad'), findsOneWidget);
  });
}
