import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'converters/date_only_converter.dart';
import 'daos/app_settings_dao.dart';
import 'tables/app_settings.dart';
import 'tables/presets.dart';
import 'tables/revenues.dart';
import 'tables/shift_overrides.dart';
import 'tables/shift_patterns.dart';
import 'tables/work_sessions.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    ShiftPatterns,
    ShiftOverrides,
    Revenues,
    WorkSessions,
    AppSettings,
    Presets,
  ],
  daos: [AppSettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();

      await into(appSettings).insert(
        AppSettingsCompanion.insert(
          monthlyClosingDay: const Value(15),
          ashikiriAmount: 0,
          commissionRate: 0.5,
          improvementStandardEnabled: true,
          maxMonthlyRestraintHours: const Value(262),
          maxMonthlyShifts: const Value(13),
          themeMode: 'system',
          isPremium: false,
          customLabels: '{}',
        ),
      );

      for (final table in [
        'shift_patterns',
        'shift_overrides',
        'revenues',
        'work_sessions',
        'app_settings',
      ]) {
        await customStatement('''
        CREATE TRIGGER ${table}_updated_at
        AFTER UPDATE ON $table
        FOR EACH ROW
        BEGIN
          UPDATE $table SET updated_at = CAST(strftime('%s', 'now') AS INTEGER) WHERE id = NEW.id;
        END;
      ''');
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'taxi_shift_app_db');
  }
}
