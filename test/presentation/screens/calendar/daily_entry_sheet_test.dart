import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:taxi_shift_app/application/providers/database_provider.dart';
import 'package:taxi_shift_app/application/providers/repositories_provider.dart';
import 'package:taxi_shift_app/data/local/database.dart'
    hide WorkSession, Revenue;
import 'package:taxi_shift_app/domain/models/revenue.dart';
import 'package:taxi_shift_app/domain/models/work_session.dart';
import 'package:taxi_shift_app/presentation/screens/calendar/widgets/daily_entry_sheet.dart';
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

  testWidgets('勤務スイッチのみ ON で保存 → WorkSession のみ作成', (
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
          home: Scaffold(body: DailyEntrySheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 両方 ON なので、売上スイッチを OFF にする
    final switches = find.byType(Switch);
    expect(switches, findsWidgets); // 翌日またぐ, 勤務, 売上 = 3つあるはず
    // SwitchListTile を探す
    final revenueSwitchTile = find.widgetWithText(SwitchListTile, '売上記録を入力する');
    await tester.ensureVisible(revenueSwitchTile);
    await tester.tap(revenueSwitchTile);
    await tester.pumpAndSettle();

    // 勤務記録の休憩時間を変更しておく
    await tester.enterText(findTextFieldByLabel('休憩時間'), '120');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    final sessionRepo = container.read(workSessionsRepositoryProvider);
    final sessions = await sessionRepo.findByMonth(2026, 6);
    expect(sessions.length, 1);
    expect(sessions.first.restMinutes, 120);

    final revenueRepo = container.read(revenuesRepositoryProvider);
    final revenues = await revenueRepo.findByMonth(2026, 6);
    expect(revenues.isEmpty, true);
  });

  testWidgets('売上スイッチのみ ON で保存 → Revenue のみ作成', (WidgetTester tester) async {
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
          home: Scaffold(body: DailyEntrySheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 勤務スイッチを OFF にする
    final workSessionSwitchTile = find.widgetWithText(
      SwitchListTile,
      '勤務記録を入力する',
    );
    await tester.ensureVisible(workSessionSwitchTile);
    await tester.tap(workSessionSwitchTile);
    await tester.pumpAndSettle();

    // 売上の総営収を入力
    await tester.enterText(findTextFieldByLabel('総営収（任意）'), '55000');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    final sessionRepo = container.read(workSessionsRepositoryProvider);
    final sessions = await sessionRepo.findByMonth(2026, 6);
    expect(sessions.isEmpty, true);

    final revenueRepo = container.read(revenuesRepositoryProvider);
    final revenues = await revenueRepo.findByMonth(2026, 6);
    expect(revenues.length, 1);
    expect(revenues.first.grossRevenue, 55000);
  });

  testWidgets('両方 ON で保存 → 両方作成', (WidgetTester tester) async {
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
          home: Scaffold(body: DailyEntrySheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // デフォルトで両方 ON
    await tester.enterText(findTextFieldByLabel('休憩時間'), '120');
    await tester.enterText(findTextFieldByLabel('総営収（任意）'), '55000');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    final sessionRepo = container.read(workSessionsRepositoryProvider);
    final sessions = await sessionRepo.findByMonth(2026, 6);
    expect(sessions.length, 1);
    expect(sessions.first.restMinutes, 120);

    final revenueRepo = container.read(revenuesRepositoryProvider);
    final revenues = await revenueRepo.findByMonth(2026, 6);
    expect(revenues.length, 1);
    expect(revenues.first.grossRevenue, 55000);
  });

  testWidgets('両方 OFF で保存 → エラー表示', (WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    final testDate = DateTime(2026, 6, 14);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(body: DailyEntrySheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 両方 OFF
    final workSwitch = find.widgetWithText(SwitchListTile, '勤務記録を入力する');
    final revSwitch = find.widgetWithText(SwitchListTile, '売上記録を入力する');
    await tester.ensureVisible(workSwitch);
    await tester.tap(workSwitch);
    await tester.ensureVisible(revSwitch);
    await tester.tap(revSwitch);
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('最低1つの記録を有効にしてください'), findsOneWidget);
  });

  testWidgets('編集モードで開くと、既存データに応じてスイッチが適切な初期状態になる', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final sessionRepo = container.read(workSessionsRepositoryProvider);
    final revenueRepo = container.read(revenuesRepositoryProvider);

    // Case 1: WorkSession only
    final testDate1 = DateTime(2026, 6);
    await sessionRepo.create(
      WorkSession(
        shiftDate: testDate1,
        startDateTime: DateTime(2026, 6, 1, 8),
        endDateTime: DateTime(2026, 6, 1, 18),
        restMinutes: 60,
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          key: UniqueKey(),
          home: Scaffold(body: DailyEntrySheet(date: testDate1)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    SwitchListTile workSwitch = tester.widget(
      find.widgetWithText(SwitchListTile, '勤務記録を入力する'),
    );
    SwitchListTile revSwitch = tester.widget(
      find.widgetWithText(SwitchListTile, '売上記録を入力する'),
    );
    expect(workSwitch.value, true);
    expect(revSwitch.value, false);

    // Case 2: Revenue only
    final testDate2 = DateTime(2026, 6, 2);
    await revenueRepo.create(
      Revenue(
        shiftDate: testDate2,
        grossRevenue: 10000,
        taxExcludedRevenue: 9091,
        cashAmount: 10000,
        cardAmount: 0,
        appAmount: 0,
        ticketAmount: 0,
        totalDistance: 100,
        occupiedDistance: 50,
        ridesCount: 10,
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          key: UniqueKey(),
          home: Scaffold(body: DailyEntrySheet(date: testDate2)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    workSwitch = tester.widget(
      find.widgetWithText(SwitchListTile, '勤務記録を入力する'),
    );
    revSwitch = tester.widget(find.widgetWithText(SwitchListTile, '売上記録を入力する'));
    expect(workSwitch.value, false);
    expect(revSwitch.value, true);
  });

  testWidgets('売上内訳ずれで確認ダイアログ表示', (WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    final testDate = DateTime(2026, 6, 15);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(body: DailyEntrySheet(date: testDate)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(findTextFieldByLabel('総営収（任意）'), '55000');
    await tester.enterText(findTextFieldByLabel('現金（任意）'), '60000');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('内訳にずれがあります'), findsOneWidget);

    // Cancel
    await tester.tap(find.text('修正する'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

    // Try again and confirm
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('このまま保存'));
    await tester.pumpAndSettle();

    final revenueRepo = container.read(revenuesRepositoryProvider);
    final revenues = await revenueRepo.findByMonth(2026, 6);
    expect(revenues.length, 1);
  });
}
