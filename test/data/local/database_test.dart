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

  test('AppSettings can be inserted and check constraint works', () async {
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
    expect(id, 1);

    final settings = await db.select(db.appSettings).get();
    expect(settings.length, 1);
    expect(settings.first.ashikiriAmount, 30000);

    // 2行目INSERTがエラーになること
    expect(
      () => db
          .into(db.appSettings)
          .insert(
            AppSettingsCompanion.insert(
              id: const Value(2), // id 2 should fail CHECK (id = 1)
              monthlyClosingDay: const Value(15),
              ashikiriAmount: 30000,
              commissionRate: 0.5,
              improvementStandardEnabled: true,
              maxMonthlyRestraintHours: const Value(262),
              maxMonthlyShifts: const Value(13),
              themeMode: 'system',
              isPremium: false,
              customLabels: '{}',
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test('updatedAt is automatically updated by trigger on update', () async {
    // 最初の挿入
    final id = await db
        .into(db.shiftPatterns)
        .insert(
          ShiftPatternsCompanion.insert(
            name: 'A班',
            workStyle: 'alternateDay',
            cycle: '[]',
            startDate: DateTime(2023),
            validFrom: DateTime(2023),
            isActive: true,
          ),
        );

    final inserted = await (db.select(
      db.shiftPatterns,
    )..where((t) => t.id.equals(id))).getSingle();
    final firstUpdatedAt = inserted.updatedAt;

    // Wait a bit to ensure timestamp changes
    await Future<void>.delayed(const Duration(milliseconds: 1000)); // wait 1s

    // 更新
    await db
        .update(db.shiftPatterns)
        .replace(inserted.copyWith(name: 'A班(更新)'));

    final updated = await (db.select(
      db.shiftPatterns,
    )..where((t) => t.id.equals(id))).getSingle();

    // トリガーによってupdatedAtが変更されていること
    expect(updated.updatedAt.isAfter(firstUpdatedAt), true);
    expect(updated.name, 'A班(更新)');
  });
}
