import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:taxi_shift_app/application/providers/database_provider.dart';
import 'package:taxi_shift_app/application/providers/repositories_provider.dart';
import 'package:taxi_shift_app/data/local/database.dart' hide WorkSession;
import 'package:taxi_shift_app/domain/models/work_session.dart';
import 'package:taxi_shift_app/presentation/screens/calendar/widgets/work_session_sheet.dart';

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

  testWidgets('WorkSessionSheet create new session test', (
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
          home: Scaffold(body: WorkSessionSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Default rest minutes should be 180
    expect(find.text('180'), findsOneWidget);

    // Save
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    // Verify DB
    final repo = container.read(workSessionsRepositoryProvider);
    final sessions = await repo.findByMonth(2026, 6);
    expect(sessions.length, 1);
    expect(sessions.first.restMinutes, 180);
    // Start time: 14:00, End time: 10:00 (+1 day)
    expect(sessions.first.startDateTime.hour, 14);
    expect(sessions.first.endDateTime.hour, 10);
    expect(sessions.first.endDateTime.day, 12);
  });

  testWidgets('WorkSessionSheet update existing session test', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final testDate = DateTime(2026, 6, 11);

    // Pre-create session
    final repo = container.read(workSessionsRepositoryProvider);
    await repo.create(
      WorkSession(
        shiftDate: testDate,
        startDateTime: DateTime(2026, 6, 11, 8),
        endDateTime: DateTime(2026, 6, 11, 18),
        restMinutes: 60,
        note: '既存メモ',
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(body: WorkSessionSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('既存メモ'), findsOneWidget);
    expect(find.text('60'), findsOneWidget);

    // Save
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    final sessions = await repo.findByMonth(2026, 6);
    expect(sessions.length, 1);
  });

  testWidgets('WorkSessionSheet delete session test', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final testDate = DateTime(2026, 6, 11);

    // Pre-create session
    final repo = container.read(workSessionsRepositoryProvider);
    await repo.create(
      WorkSession(
        shiftDate: testDate,
        startDateTime: DateTime(2026, 6, 11, 8),
        endDateTime: DateTime(2026, 6, 11, 18),
        restMinutes: 60,
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(body: WorkSessionSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('削除'));
    await tester.pumpAndSettle();

    final sessions = await repo.findByMonth(2026, 6);
    expect(sessions.isEmpty, true);
  });

  testWidgets('WorkSessionSheet validation error test', (
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
          home: Scaffold(body: WorkSessionSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Disable next day switch to make end time 10:00 on the same day (before 14:00)
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    // Snackbar should appear
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text('startDateTime must be before endDateTime'),
      findsOneWidget,
    );
  });
}
