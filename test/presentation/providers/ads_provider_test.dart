import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/domain/models/app_settings.dart';
import 'package:taxi_shift_app/presentation/providers/ad_runtime_provider.dart';
import 'package:taxi_shift_app/presentation/providers/ads_provider.dart';
import 'package:taxi_shift_app/presentation/providers/app_settings_queries_provider.dart';

class _FixedAdRuntimeController extends AdRuntimeController {
  final AdRuntimeState initialState;

  _FixedAdRuntimeController(this.initialState);

  @override
  AdRuntimeState build() => initialState;
}

void main() {
  const freeSettings = AppSettings(
    monthlyClosingDay: 15,
    ashikiriAmount: 0,
    commissionRate: 0.5,
    improvementStandardEnabled: true,
    maxMonthlyRestraintHours: 262,
    maxMonthlyShifts: 13,
    themeMode: ThemeMode.system,
    isPremium: false,
    customLabels: {},
  );

  test('無料ユーザーかつ広告SDK準備済みなら広告を表示する', () {
    final container = ProviderContainer(
      overrides: [
        appSettingsProvider.overrideWithValue(const AsyncData(freeSettings)),
        adRuntimeControllerProvider.overrideWith(
          () => _FixedAdRuntimeController(
            const AdRuntimeState(
              status: AdRuntimeStatus.ready,
              adUnitId: 'test-banner',
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(adsEnabledProvider), true);
  });

  test('プレミアムユーザーは広告表示が無効', () async {
    final container = ProviderContainer(
      overrides: [
        appSettingsProvider.overrideWithValue(
          AsyncData(freeSettings.copyWith(isPremium: true)),
        ),
        adRuntimeControllerProvider.overrideWith(
          () => _FixedAdRuntimeController(
            const AdRuntimeState(
              status: AdRuntimeStatus.ready,
              adUnitId: 'test-banner',
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(adsEnabledProvider), false);
  });

  test('広告SDKの準備前は無料ユーザーでも広告枠を表示しない', () {
    final container = ProviderContainer(
      overrides: [
        appSettingsProvider.overrideWithValue(const AsyncData(freeSettings)),
        adRuntimeControllerProvider.overrideWith(
          () => _FixedAdRuntimeController(const AdRuntimeState.idle()),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(adsEnabledProvider), false);
  });

  test('設定の読み込み前は広告枠を表示しない', () {
    final container = ProviderContainer(
      overrides: [
        appSettingsProvider.overrideWithValue(const AsyncLoading()),
        adRuntimeControllerProvider.overrideWith(
          () => _FixedAdRuntimeController(
            const AdRuntimeState(
              status: AdRuntimeStatus.ready,
              adUnitId: 'test-banner',
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(adsEnabledProvider), false);
  });
}
