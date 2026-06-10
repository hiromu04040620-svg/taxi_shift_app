import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/data/local/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
  });

  tearDown(() async {
    await db.close();
  });

  test('AppDatabase can be instantiated and closed in memory', () async {
    // 常に1のAppSettings等、適当に1件insertできるかどうかのsmoke test
    final id = await db
        .into(db.appSettings)
        .insert(
          AppSettingsCompanion.insert(
            monthlyClosingDay: const Value(15),
            ashikiriAmount: 30000,
            commissionRate: 0.5,
            improvementStandardEnabled: true,
            maxMonthlyRestraintHours: const Value(262),
            maxMonthlyShifts: const Value(13),
            themeMode: 'system',
            isPremium: false,
            customLabels: '{}',
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
    expect(id != 0, true);

    final settings = await db.select(db.appSettings).get();
    expect(settings.length, 1);
    expect(settings.first.ashikiriAmount, 30000);
  });
}
