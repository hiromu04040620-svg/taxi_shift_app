import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:taxi_shift_app/application/providers/database_provider.dart';
import 'package:taxi_shift_app/application/providers/repositories_provider.dart';
import 'package:taxi_shift_app/data/local/database.dart'
    hide ShiftOverride, ShiftPattern;
import 'package:taxi_shift_app/domain/models/shift_override.dart';
import 'package:taxi_shift_app/domain/models/shift_pattern.dart';
import 'package:taxi_shift_app/domain/models/shift_type.dart';
import 'package:taxi_shift_app/domain/models/work_style.dart';
import 'package:taxi_shift_app/presentation/screens/calendar/widgets/shift_change_confirm_dialog.dart';
import 'package:taxi_shift_app/presentation/screens/calendar/widgets/shift_override_sheet.dart';

void main() {
  late AppDatabase db;

  setUpAll(() async {
    await initializeDateFormatting('ja_JP');
  });

  setUp(() async {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    await db.customStatement('PRAGMA foreign_keys = ON');
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('ShiftChangeConfirmDialog UI and Cancel Test', (
    WidgetTester tester,
  ) async {
    final testDate = DateTime(2026, 6, 11);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ShiftChangeConfirmDialog(
            date: testDate,
            selectedType: ShiftType.dayOff,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('シフトを変更'), findsOneWidget);
    expect(find.text('この日だけ変更'), findsOneWidget);
    expect(find.text('ここからサイクル変更'), findsOneWidget);
    expect(find.text('キャンセル'), findsOneWidget);

    await tester.tap(find.text('キャンセル'));
    await tester.pumpAndSettle();
  });

  testWidgets('ShiftOverrideSheet override and cycle change flows', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final patternsRepo = container.read(shiftPatternsRepositoryProvider);
    final overridesRepo = container.read(shiftOverridesRepositoryProvider);

    // Setup active pattern
    final testDate = DateTime(2026, 6, 11); // Thursday
    // startDate: 2026-06-01.
    // pattern: workDay, dayOff, afterDuty
    await patternsRepo.create(
      ShiftPattern(
        id: 0,
        name: 'Test Pattern',
        workStyle: WorkStyle.dayShift,
        cycle: [ShiftType.workDay, ShiftType.dayOff, ShiftType.afterDuty],
        startDate: DateTime(2026, 6),
        validFrom: DateTime(2026, 6),
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    // Also create an override on another day to ensure it's maintained
    final otherDate = DateTime(2026, 6, 15);
    await overridesRepo.upsertSingle(
      ShiftOverride(
        id: 0,
        date: otherDate,
        shiftType: ShiftType.paidLeave,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    // ----- Flow 1: "この日だけ変更" -----
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          key: UniqueKey(),
          home: Scaffold(body: ShiftOverrideSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Select '公' (dayOff)
    await tester.tap(find.text('公'));
    await tester.pumpAndSettle();

    // Save
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    // Dialog appears
    expect(find.byType(ShiftChangeConfirmDialog), findsOneWidget);
    await tester.tap(find.text('この日だけ変更'));
    await tester.pumpAndSettle();

    // Verify DB
    final overrides = await overridesRepo.getAll();
    expect(overrides.length, 2); // otherDate + testDate
    var overrideOnTestDate = await overridesRepo.getByDate(testDate);
    expect(overrideOnTestDate, isNotNull);
    expect(overrideOnTestDate!.shiftType, ShiftType.dayOff);

    // ----- Flow 2: "ここからサイクル変更" -----
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          key: UniqueKey(),
          home: Scaffold(body: ShiftOverrideSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // The existing override should be visible, so it's currently '公'
    // Let's select '明' (afterDuty) to reset the cycle to '明' at testDate.
    await tester.tap(find.text('明'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    // Dialog appears
    expect(find.byType(ShiftChangeConfirmDialog), findsOneWidget);
    await tester.tap(find.text('ここからサイクル変更'));
    await tester.pumpAndSettle();

    // Second Dialog appears
    expect(find.text('サイクルを変更しますか？'), findsOneWidget);
    await tester.tap(find.text('サイクルを変更'));
    await tester.pumpAndSettle();

    // Verify DB
    // 1. The override on testDate should be deleted
    overrideOnTestDate = await overridesRepo.getByDate(testDate);
    expect(overrideOnTestDate, isNull);

    // 2. The override on otherDate should remain
    final overrideOnOtherDate = await overridesRepo.getByDate(otherDate);
    expect(overrideOnOtherDate, isNotNull);

    // 3. The shift pattern startDate should be shifted.
    // testDate is 2026-06-11. We selected ShiftType.afterDuty.
    // 'afterDuty' is at index 2 in the cycle [workDay, dayOff, afterDuty].
    // So new startDate = 2026-06-11 - 2 days = 2026-06-09.
    final updatedPattern = await patternsRepo.getActiveAt(testDate);
    expect(updatedPattern!.startDate, DateTime(2026, 6, 9));
  });
}
