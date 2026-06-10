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

  test(
    'AppSettings is populated on create and check constraint works',
    () async {
      // 初回起動時に AppSettings の id=1 レコードが初期値で作成されること
      final settings = await db.select(db.appSettings).get();
      expect(settings.length, 1);

      final initial = settings.first;
      expect(initial.id, 1);
      expect(initial.monthlyClosingDay, 15);
      expect(initial.ashikiriAmount, 0);
      expect(initial.commissionRate, 0.5);
      expect(initial.improvementStandardEnabled, true);
      expect(initial.maxMonthlyRestraintHours, 262);
      expect(initial.maxMonthlyShifts, 13);
      expect(initial.themeMode, 'system');
      expect(initial.isPremium, false);
      expect(initial.customLabels, '{}');

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
    },
  );

  test('updatedAt is automatically updated by trigger on update', () async {
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

    await Future<void>.delayed(const Duration(milliseconds: 1000));

    await db
        .update(db.shiftPatterns)
        .replace(inserted.copyWith(name: 'A班(更新)'));

    final updated = await (db.select(
      db.shiftPatterns,
    )..where((t) => t.id.equals(id))).getSingle();
    expect(updated.updatedAt.isAfter(firstUpdatedAt), true);
    expect(updated.name, 'A班(更新)');
  });

  test(
    'DateOnlyConverter saves date as YYYY-MM-DD and rejects invalid formats',
    () async {
      final testDate = DateTime(2023, 5, 4, 12, 34, 56);

      final id = await db
          .into(db.workSessions)
          .insert(
            WorkSessionsCompanion.insert(
              date: testDate,
              startTime: testDate,
              endTime: testDate.add(const Duration(hours: 8)),
              breakMinutes: 60,
            ),
          );

      // DB内では 'YYYY-MM-DD' 形式で保持されることを raw query で確認
      final rawResult = await db
          .customSelect(
            'SELECT date FROM work_sessions WHERE id = ?',
            variables: [Variable(id)],
          )
          .getSingle();
      expect(rawResult.read<String>('date'), '2023-05-04');

      // 通常のselectでDateTimeとして正しく復元されること
      final parsed = await (db.select(
        db.workSessions,
      )..where((t) => t.id.equals(id))).getSingle();
      expect(parsed.date.year, 2023);
      expect(parsed.date.month, 5);
      expect(parsed.date.day, 4);

      // 不正フォーマット文字列を直接 INSERT した場合の挙動（parse エラーになることを確認）
      await db.customInsert(
        'INSERT INTO work_sessions (date, start_time, end_time, break_minutes) VALUES (?, ?, ?, ?)',
        variables: [
          const Variable('2023/05/04'), // invalid format
          Variable(DateTime.now().millisecondsSinceEpoch ~/ 1000),
          Variable(DateTime.now().millisecondsSinceEpoch ~/ 1000),
          const Variable(60),
        ],
      );

      expect(
        () async => await db.select(db.workSessions).get(),
        throwsA(isA<FormatException>()),
      );
    },
  );
}
