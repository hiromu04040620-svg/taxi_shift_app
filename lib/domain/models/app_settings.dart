import 'package:flutter/material.dart' show ThemeMode;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    required int monthlyClosingDay,
    required int ashikiriAmount,
    required double commissionRate,
    required bool improvementStandardEnabled,
    required int maxMonthlyRestraintHours,
    required int maxMonthlyShifts,
    required ThemeMode themeMode,
    required bool isPremium,
    required Map<String, String> customLabels,
  }) = _AppSettings;
}
