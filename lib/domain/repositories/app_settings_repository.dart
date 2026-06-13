import 'package:flutter/material.dart' show ThemeMode;
import '../models/app_settings.dart';

abstract class AppSettingsRepository {
  Future<AppSettings> get();
  Stream<AppSettings> watch();
  Future<void> updateMonthlyClosingDay(int day);
  Future<void> updateAshikiriAmount(int amount);
  Future<void> updateCommissionRate(double rate);
  Future<void> updateThemeMode(ThemeMode mode);
  Future<void> updateImprovementStandardEnabled(bool enabled);
  Future<void> updateMaxMonthlyShifts(int count);
  Future<void> updateMaxMonthlyRestraintHours(int hours);
  Future<void> updatePremiumStatus(bool isPremium);
  Future<void> deleteAllUserData();
}
