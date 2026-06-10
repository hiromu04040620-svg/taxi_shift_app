import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart' show ThemeMode;

import '../../domain/models/app_settings.dart';
import '../local/daos/app_settings_dao.dart';
import '../local/database.dart' as db;

abstract class AppSettingsRepository {
  Future<AppSettings> get();
  Stream<AppSettings> watch();
  Future<void> updateClosingDay(int day);
  Future<void> updateAshikiriAmount(int amount);
  Future<void> updateCommissionRate(double rate);
  Future<void> updateThemeMode(ThemeMode mode);
}

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsDao _dao;

  AppSettingsRepositoryImpl(this._dao);

  @override
  Future<AppSettings> get() async {
    final row = await _dao.getSettings();
    return _mapToDomain(row);
  }

  @override
  Stream<AppSettings> watch() {
    return _dao.watchSettings().map(_mapToDomain);
  }

  @override
  Future<void> updateClosingDay(int day) async {
    if (day < 1 || day > 31) {
      throw ArgumentError('Closing day must be between 1 and 31');
    }
    await _dao.updateSettings(
      db.AppSettingsCompanion(monthlyClosingDay: drift.Value(day)),
    );
  }

  @override
  Future<void> updateAshikiriAmount(int amount) async {
    if (amount < 0) {
      throw ArgumentError('Ashikiri amount cannot be negative');
    }
    await _dao.updateSettings(
      db.AppSettingsCompanion(ashikiriAmount: drift.Value(amount)),
    );
  }

  @override
  Future<void> updateCommissionRate(double rate) async {
    if (rate < 0.0 || rate > 1.0) {
      throw ArgumentError('Commission rate must be between 0.0 and 1.0');
    }
    await _dao.updateSettings(
      db.AppSettingsCompanion(commissionRate: drift.Value(rate)),
    );
  }

  @override
  Future<void> updateThemeMode(ThemeMode mode) async {
    await _dao.updateSettings(
      db.AppSettingsCompanion(themeMode: drift.Value(mode.name)),
    );
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
