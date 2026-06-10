import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

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
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'taxi_shift_app_db');
  }
}
