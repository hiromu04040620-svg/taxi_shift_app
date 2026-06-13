import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:taxi_shift_app/application/providers/database_provider.dart';
import 'package:taxi_shift_app/application/providers/repositories_provider.dart';
import 'package:taxi_shift_app/data/local/database.dart' hide Revenue;
import 'package:taxi_shift_app/domain/models/revenue.dart';
import 'package:taxi_shift_app/presentation/screens/calendar/widgets/revenue_sheet.dart';
import 'package:taxi_shift_app/presentation/widgets/labeled_text_field.dart';

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

  Finder findTextFieldByLabel(String label) {
    return find.descendant(
      of: find.ancestor(
        of: find.text(label),
        matching: find.byType(LabeledTextField),
      ),
      matching: find.byType(TextField),
    );
  }

  testWidgets('RevenueSheet create new revenue test', (
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
          key: UniqueKey(),
          home: Scaffold(body: RevenueSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(findTextFieldByLabel('総営収（任意）'), '55000');
    await tester.pumpAndSettle();

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    expect(find.text('50000'), findsOneWidget);

    await tester.tap(find.text('内訳'));
    await tester.pumpAndSettle();

    await tester.enterText(findTextFieldByLabel('現金（任意）'), '55000');
    await tester.pumpAndSettle();

    final distanceField = findTextFieldByLabel('総走行距離（任意）');
    await tester.ensureVisible(distanceField);
    await tester.enterText(distanceField, '200');
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    final repo = container.read(revenuesRepositoryProvider);
    final revenues = await repo.findByMonth(2026, 6);
    expect(revenues.length, 1);
    expect(revenues.first.grossRevenue, 55000);
    expect(revenues.first.taxExcludedRevenue, 50000);
    expect(revenues.first.totalDistance, 200.0);
  });

  testWidgets('RevenueSheet saves with only gross revenue test', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final testDate = DateTime(2026, 6, 12);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          key: UniqueKey(),
          home: Scaffold(body: RevenueSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(findTextFieldByLabel('総営収（任意）'), '10000');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    final repo = container.read(revenuesRepositoryProvider);
    final revenues = await repo.findByMonth(2026, 6);
    final saved = revenues.firstWhere((r) => r.shiftDate == testDate);
    expect(saved.grossRevenue, 10000);
    expect(saved.cashAmount, 0); // Not inputted, defaults to 0
    expect(saved.totalDistance, 0.0);
  });

  testWidgets('RevenueSheet validation error when all fields are empty test', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final testDate = DateTime(2026, 6, 13);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          key: UniqueKey(),
          home: Scaffold(body: RevenueSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap save without entering anything
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('最低1項目は入力してください'), findsOneWidget);
  });

  testWidgets('RevenueSheet mismatch confirmation dialog - cancel test', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final testDate = DateTime(2026, 6, 14);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          key: UniqueKey(),
          home: Scaffold(body: RevenueSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(findTextFieldByLabel('総営収（任意）'), '55000');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(find.text('内訳'));
    await tester.pumpAndSettle();

    // Enter a mismatching amount
    await tester.enterText(findTextFieldByLabel('現金（任意）'), '60000');
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('内訳にずれがあります'), findsOneWidget);

    // Tap cancel
    await tester.tap(find.text('修正する'));
    await tester.pumpAndSettle();

    // Dialog should be closed, but RevenueSheet should still be there
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(RevenueSheet), findsOneWidget);

    final repo = container.read(revenuesRepositoryProvider);
    final revenues = await repo.findByMonth(2026, 6);
    expect(revenues.any((r) => r.shiftDate == testDate), isFalse);
  });

  testWidgets('RevenueSheet mismatch confirmation dialog - confirm test', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final testDate = DateTime(2026, 6, 15);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          key: UniqueKey(),
          home: Scaffold(body: RevenueSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(findTextFieldByLabel('総営収（任意）'), '55000');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(find.text('内訳'));
    await tester.pumpAndSettle();

    // Enter a mismatching amount
    await tester.enterText(findTextFieldByLabel('現金（任意）'), '60000');
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.byType(AlertDialog), findsOneWidget);

    // Tap confirm
    await tester.tap(find.text('このまま保存'));
    await tester.pumpAndSettle();

    // Both Dialog and RevenueSheet should be closed
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(RevenueSheet), findsNothing);

    final repo = container.read(revenuesRepositoryProvider);
    final revenues = await repo.findByMonth(2026, 6);
    final saved = revenues.firstWhere((r) => r.shiftDate == testDate);
    expect(saved.grossRevenue, 55000);
    expect(saved.cashAmount, 60000); // Saved with mismatch
  });

  testWidgets('RevenueSheet update and delete test', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final testDate = DateTime(2026, 6, 11);
    final repo = container.read(revenuesRepositoryProvider);
    await repo.create(
      Revenue(
        shiftDate: testDate,
        grossRevenue: 50000,
        taxExcludedRevenue: 45455,
        cashAmount: 50000,
        cardAmount: 0,
        appAmount: 0,
        ticketAmount: 0,
        totalDistance: 100,
        occupiedDistance: 50,
        ridesCount: 20,
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          key: UniqueKey(),
          home: Scaffold(body: RevenueSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('50000'), findsWidgets);

    await tester.tap(find.text('内訳'));
    await tester.pumpAndSettle();

    await tester.enterText(findTextFieldByLabel('現金（任意）'), '60000');
    await tester.pump();

    await tester.enterText(findTextFieldByLabel('総営収（任意）'), '60000');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    var revenues = await repo.findByMonth(2026, 6);
    expect(revenues.length, 1);
    expect(revenues.first.grossRevenue, 60000);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          key: UniqueKey(),
          home: Scaffold(body: RevenueSheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('削除'));
    await tester.pumpAndSettle();

    revenues = await repo.findByMonth(2026, 6);
    expect(revenues.isEmpty, true);
  });
}
