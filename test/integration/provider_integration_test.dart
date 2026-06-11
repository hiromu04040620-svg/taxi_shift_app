import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/application/providers/database_provider.dart';
import 'package:taxi_shift_app/application/providers/repositories_provider.dart';
import 'package:taxi_shift_app/data/local/database.dart'
    hide ShiftPattern, WorkSession, Revenue;
import 'package:taxi_shift_app/domain/models/revenue.dart';
import 'package:taxi_shift_app/domain/models/shift_pattern.dart';
import 'package:taxi_shift_app/domain/models/shift_type.dart';
import 'package:taxi_shift_app/domain/models/work_session.dart';
import 'package:taxi_shift_app/domain/models/work_style.dart';
import 'package:taxi_shift_app/presentation/providers/revenue_queries_provider.dart';
import 'package:taxi_shift_app/presentation/providers/shift_queries_provider.dart';
import 'package:taxi_shift_app/presentation/providers/work_session_queries_provider.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() async {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    await db.customStatement('PRAGMA foreign_keys = ON');
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('ShiftPattern を1件登録 → activeShiftPatternProvider で取得できる', () async {
    final repo = container.read(shiftPatternsRepositoryProvider);
    final pattern = ShiftPattern(
      id: 0,
      name: 'テストパターン',
      workStyle: WorkStyle.alternateDay,
      cycle: [ShiftType.workDay, ShiftType.afterDuty, ShiftType.dayOff],
      startDate: DateTime(2023),
      validFrom: DateTime(2023),
      isActive: true,
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023),
    );
    await repo.create(pattern);

    final activePattern = await container.read(
      activeShiftPatternProvider.future,
    );
    expect(activePattern, isNotNull);
    expect(activePattern!.name, 'テストパターン');
  });

  test(
    'ShiftPattern 登録 → shiftTypeForDateProvider が想定の ShiftType を返す',
    () async {
      final repo = container.read(shiftPatternsRepositoryProvider);
      final pattern = ShiftPattern(
        id: 0,
        name: 'テストパターン',
        workStyle: WorkStyle.alternateDay,
        cycle: [ShiftType.workDay, ShiftType.afterDuty, ShiftType.dayOff],
        startDate: DateTime(2023),
        validFrom: DateTime(2023),
        isActive: true,
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      );
      await repo.create(pattern);

      final type1 = await container.read(
        shiftTypeForDateProvider(DateTime(2023)).future,
      );
      expect(type1, ShiftType.workDay);

      final type4 = await container.read(
        shiftTypeForDateProvider(DateTime(2023, 1, 4)).future,
      );
      expect(type4, ShiftType.workDay);
    },
  );

  test('WorkSession 登録 → workSessionForDateProvider で取得できる', () async {
    final repo = container.read(workSessionsRepositoryProvider);
    final session = WorkSession(
      shiftDate: DateTime(2023),
      startDateTime: DateTime(2023, 1, 1, 8),
      endDateTime: DateTime(2023, 1, 2, 2),
      restMinutes: 180,
    );
    await repo.create(session);

    final result = await container.read(
      workSessionForDateProvider(DateTime(2023)).future,
    );
    expect(result, isNotNull);
    expect(result!.totalDurationMinutes, 18 * 60);
  });

  test('Revenue 複数登録 → monthlySummaryProvider が正しく集計', () async {
    final repo = container.read(revenuesRepositoryProvider);
    final rev1 = Revenue(
      shiftDate: DateTime(2023),
      grossRevenue: 50000,
      taxExcludedRevenue: 45000,
      cashAmount: 20000,
      cardAmount: 15000,
      appAmount: 10000,
      ticketAmount: 5000,
      totalDistance: 200,
      occupiedDistance: 100,
      ridesCount: 20,
    );
    final rev2 = Revenue(
      shiftDate: DateTime(2023, 1, 2),
      grossRevenue: 40000,
      taxExcludedRevenue: 36000,
      cashAmount: 10000,
      cardAmount: 10000,
      appAmount: 20000,
      ticketAmount: 0,
      totalDistance: 150,
      occupiedDistance: 90,
      ridesCount: 15,
    );

    await repo.create(rev1);
    await repo.create(rev2);

    final arg = (year: 2023, month: 1);
    final summary = await container.read(monthlySummaryProvider(arg).future);

    expect(summary.totalGrossRevenue, 90000);
    expect(summary.totalShiftsCount, 2);
    expect(summary.totalDistance, 350);
  });
}
