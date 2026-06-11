import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../application/providers/database_provider.dart';
import '../../../../application/providers/repositories_provider.dart';
import '../../../../data/local/database.dart' as db;

part 'settings_actions_provider.g.dart';

@riverpod
class SettingsActions extends _$SettingsActions {
  @override
  void build() {}

  Future<void> updateClosingDay(int day) async {
    final repo = ref.read(appSettingsRepositoryProvider);
    await repo.updateClosingDay(day);
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
    final database = ref.read(appDatabaseProvider);
    await database.appSettingsDao.updateSettings(
      db.AppSettingsCompanion(improvementStandardEnabled: Value(enabled)),
    );
  }

  Future<void> updateMaxMonthlyShifts(int shifts) async {
    final database = ref.read(appDatabaseProvider);
    await database.appSettingsDao.updateSettings(
      db.AppSettingsCompanion(maxMonthlyShifts: Value(shifts)),
    );
  }

  Future<void> updateMaxMonthlyRestraintHours(int hours) async {
    final database = ref.read(appDatabaseProvider);
    await database.appSettingsDao.updateSettings(
      db.AppSettingsCompanion(maxMonthlyRestraintHours: Value(hours)),
    );
  }

  Future<void> deleteAllData() async {
    final database = ref.read(appDatabaseProvider);
    await database.transaction(() async {
      await database.delete(database.shiftPatterns).go();
      await database.delete(database.shiftOverrides).go();
      await database.delete(database.revenues).go();
      await database.delete(database.workSessions).go();
      // Keep appSettings intact or reset them? MVP: usually preserve settings.
    });
  }
}
