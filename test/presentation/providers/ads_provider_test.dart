import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/domain/models/app_settings.dart';
import 'package:taxi_shift_app/presentation/providers/ads_provider.dart';
import 'package:taxi_shift_app/presentation/providers/app_settings_queries_provider.dart';

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

  test('無料ユーザーは広告枠を表示する', () {
    final container = ProviderContainer(
      overrides: [
        appSettingsProvider.overrideWithValue(const AsyncData(freeSettings)),
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
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(adsEnabledProvider), false);
  });
}
