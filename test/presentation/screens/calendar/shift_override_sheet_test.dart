import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:taxi_shift_app/application/providers/database_provider.dart';
import 'package:taxi_shift_app/application/providers/repositories_provider.dart';
import 'package:taxi_shift_app/data/local/database.dart' hide ShiftOverride;
import 'package:taxi_shift_app/domain/models/shift_override.dart';
import 'package:taxi_shift_app/domain/models/shift_type.dart';
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

  testWidgets('ShiftOverrideSheet create new override test', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final testDate = DateTime(2026, 6, 11);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(body: ShiftOverrideSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Select '公'
    await tester.tap(find.text('公'));
    await tester.pumpAndSettle();

    // Enter note
    await tester.enterText(find.byType(TextField), '私用のため');
    await tester.pumpAndSettle();

    // Save
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    // Verify DB
    final repo = container.read(shiftOverridesRepositoryProvider);
    final overrides = await repo.getAll();
    expect(overrides.length, 1);
    expect(overrides.first.shiftType, ShiftType.dayOff);
    expect(overrides.first.reason, '私用のため');
  });

  testWidgets('ShiftOverrideSheet update existing override test', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final testDate = DateTime(2026, 6, 11);

    // Pre-create override
    final repo = container.read(shiftOverridesRepositoryProvider);
    await repo.upsertSingle(
      ShiftOverride(
        id: 0,
        date: testDate,
        shiftType: ShiftType.workDay,
        reason: '既存のメモ',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(body: ShiftOverrideSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Existing note should be visible
    expect(find.text('既存のメモ'), findsOneWidget);

    // Select '明'
    await tester.tap(find.text('明'));
    await tester.pumpAndSettle();

    // Save
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    // Verify DB updated
    final overrides = await repo.getAll();
    expect(overrides.length, 1);
    expect(overrides.first.shiftType, ShiftType.afterDuty);
  });

  testWidgets('ShiftOverrideSheet reset test', (WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final testDate = DateTime(2026, 6, 11);

    final repo = container.read(shiftOverridesRepositoryProvider);
    await repo.upsertSingle(
      ShiftOverride(
        id: 0,
        date: testDate,
        shiftType: ShiftType.workDay,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(body: ShiftOverrideSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap reset
    await tester.tap(find.text('リセット'));
    await tester.pumpAndSettle();

    // Verify DB deleted
    final overrides = await repo.getAll();
    expect(overrides.isEmpty, true);
  });
}
