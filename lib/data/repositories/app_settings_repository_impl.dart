import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart' show ThemeMode;

import '../../domain/models/app_settings.dart';
import '../../domain/repositories/app_settings_repository.dart';
import '../local/database.dart' as db;

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final db.AppDatabase _db;

  AppSettingsRepositoryImpl(this._db);

  @override
  Future<AppSettings> get() async {
    final row = await _db.appSettingsDao.getSettings();
    return _mapToDomain(row);
  }

  @override
  Stream<AppSettings> watch() {
    return _db.appSettingsDao.watchSettings().map(_mapToDomain);
  }

  @override
  Future<void> updateMonthlyClosingDay(int day) async {
    if (day < 1 || day > 31) {
      throw ArgumentError('Closing day must be between 1 and 31');
    }
    await _db.appSettingsDao.updateSettings(
      db.AppSettingsCompanion(monthlyClosingDay: drift.Value(day)),
    );
  }

  @override
  Future<void> updateAshikiriAmount(int amount) async {
    if (amount < 0) {
      throw ArgumentError('Ashikiri amount cannot be negative');
    }
    await _db.appSettingsDao.updateSettings(
      db.AppSettingsCompanion(ashikiriAmount: drift.Value(amount)),
    );
  }

  @override
  Future<void> updateCommissionRate(double rate) async {
    if (rate < 0.0 || rate > 1.0) {
      throw ArgumentError('Commission rate must be between 0.0 and 1.0');
    }
    await _db.appSettingsDao.updateSettings(
      db.AppSettingsCompanion(commissionRate: drift.Value(rate)),
    );
  }

  @override
  Future<void> updateThemeMode(ThemeMode mode) async {
    await _db.appSettingsDao.updateSettings(
      db.AppSettingsCompanion(themeMode: drift.Value(mode.name)),
    );
  }

  @override
  Future<void> updateImprovementStandardEnabled(bool enabled) async {
    await _db.appSettingsDao.updateSettings(
      db.AppSettingsCompanion(improvementStandardEnabled: drift.Value(enabled)),
    );
  }

  @override
  Future<void> updateMaxMonthlyShifts(int count) async {
    if (count < 1) throw ArgumentError('Count must be at least 1');
    await _db.appSettingsDao.updateSettings(
      db.AppSettingsCompanion(maxMonthlyShifts: drift.Value(count)),
    );
  }

  @override
  Future<void> updateMaxMonthlyRestraintHours(int hours) async {
    if (hours < 1) throw ArgumentError('Hours must be at least 1');
    await _db.appSettingsDao.updateSettings(
      db.AppSettingsCompanion(maxMonthlyRestraintHours: drift.Value(hours)),
    );
  }

  @override
  Future<void> deleteAllUserData() async {
    await _db.transaction(() async {
      await _db.delete(_db.shiftOverrides).go();
      await _db.delete(_db.revenues).go();
      await _db.delete(_db.workSessions).go();
    });
  }

  AppSettings _mapToDomain(db.AppSetting row) {
    Map<String, String> labels = {};
    try {
      final decoded = jsonDecode(row.customLabels);
      if (decoded is Map) {
        labels = decoded.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        );
      }
    } catch (_) {
      // JSON decode error, use empty map
    }

    ThemeMode mode;
    switch (row.themeMode) {
      case 'light':
        mode = ThemeMode.light;
        break;
      case 'dark':
        mode = ThemeMode.dark;
        break;
      case 'system':
      default:
        mode = ThemeMode.system;
        break;
    }

    return AppSettings(
      monthlyClosingDay: row.monthlyClosingDay,
      ashikiriAmount: row.ashikiriAmount,
      commissionRate: row.commissionRate,
      improvementStandardEnabled: row.improvementStandardEnabled,
      maxMonthlyRestraintHours: row.maxMonthlyRestraintHours,
      maxMonthlyShifts: row.maxMonthlyShifts,
      themeMode: mode,
      isPremium: row.isPremium,
      customLabels: labels,
    );
  }
}
