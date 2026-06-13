import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/data/local/database.dart';
import 'package:taxi_shift_app/data/repositories/app_settings_repository_impl.dart';
import 'package:taxi_shift_app/domain/repositories/app_settings_repository.dart';

void main() {
  late AppDatabase db;
  late AppSettingsRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    repository = AppSettingsRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('AppSettingsRepository validations', () {
    test(
      'updateMonthlyClosingDay throws ArgumentError on boundaries',
      () async {
        expect(
          () => repository.updateMonthlyClosingDay(0),
          throwsArgumentError,
        );
        expect(
          () => repository.updateMonthlyClosingDay(32),
          throwsArgumentError,
        );

        await repository.updateMonthlyClosingDay(1);
        final settingsMin = await repository.get();
        expect(settingsMin.monthlyClosingDay, 1);

        await repository.updateMonthlyClosingDay(31);
        final settingsMax = await repository.get();
        expect(settingsMax.monthlyClosingDay, 31);
      },
    );

    test('updateAshikiriAmount throws ArgumentError on negative', () async {
      expect(() => repository.updateAshikiriAmount(-1), throwsArgumentError);

      await repository.updateAshikiriAmount(0);
      final settings = await repository.get();
      expect(settings.ashikiriAmount, 0);
    });

    test('updateCommissionRate throws ArgumentError on boundaries', () async {
      expect(() => repository.updateCommissionRate(-0.1), throwsArgumentError);
      expect(() => repository.updateCommissionRate(1.1), throwsArgumentError);

      await repository.updateCommissionRate(0);
      final settingsMin = await repository.get();
      expect(settingsMin.commissionRate, 0);

      await repository.updateCommissionRate(1);
      final settingsMax = await repository.get();
      expect(settingsMax.commissionRate, 1);
    });
  });

  group('AppSettingsRepository mappings', () {
    test('ThemeMode enum maps correctly', () async {
      await repository.updateThemeMode(ThemeMode.dark);
      var settings = await repository.get();
      expect(settings.themeMode, ThemeMode.dark);

      await repository.updateThemeMode(ThemeMode.light);
      settings = await repository.get();
      expect(settings.themeMode, ThemeMode.light);
    });

    test('customLabels json decodes correctly', () async {
      // In db default it's '{}'
      final settings = await repository.get();
      expect(settings.customLabels, isEmpty);

      // To update it we bypass repository mapping (or add updateCustomLabels)
      // Since repository doesn't have updateCustomLabels yet, we check initial state.
    });

    test('premium status can be updated', () async {
      var settings = await repository.get();
      expect(settings.isPremium, false);

      await repository.updatePremiumStatus(true);
      settings = await repository.get();
      expect(settings.isPremium, true);

      await repository.updatePremiumStatus(false);
      settings = await repository.get();
      expect(settings.isPremium, false);
    });
  });
}
