import 'package:flutter/material.dart' show ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'repositories_provider.dart';

part 'app_settings_controller.g.dart';

@riverpod
class AppSettingsController extends _$AppSettingsController {
  @override
  void build() {}

  Future<void> updateMonthlyClosingDay(int day) async {
    final repo = ref.read(appSettingsRepositoryProvider);
    await repo.updateMonthlyClosingDay(day);
  }

  Future<void> updateAshikiriAmount(int amount) async {
    final repo = ref.read(appSettingsRepositoryProvider);
    await repo.updateAshikiriAmount(amount);
  }

  Future<void> updateCommissionRate(double rate) async {
    final repo = ref.read(appSettingsRepositoryProvider);
    await repo.updateCommissionRate(rate);
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final repo = ref.read(appSettingsRepositoryProvider);
    await repo.updateThemeMode(mode);
  }

  Future<void> updateImprovementStandardEnabled(bool enabled) async {
    final repo = ref.read(appSettingsRepositoryProvider);
    await repo.updateImprovementStandardEnabled(enabled);
  }

  Future<void> updateMaxMonthlyShifts(int shifts) async {
    final repo = ref.read(appSettingsRepositoryProvider);
    await repo.updateMaxMonthlyShifts(shifts);
  }

  Future<void> updateMaxMonthlyRestraintHours(int hours) async {
    final repo = ref.read(appSettingsRepositoryProvider);
    await repo.updateMaxMonthlyRestraintHours(hours);
  }

  Future<void> updatePremiumStatus(bool isPremium) async {
    final repo = ref.read(appSettingsRepositoryProvider);
    await repo.updatePremiumStatus(isPremium);
  }

  Future<void> deleteAllUserData() async {
    final repo = ref.read(appSettingsRepositoryProvider);
    await repo.deleteAllUserData();
  }
}
