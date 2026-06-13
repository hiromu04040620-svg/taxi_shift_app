import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:taxi_shift_app/application/providers/database_provider.dart';
import 'package:taxi_shift_app/application/providers/onboarding_provider.dart';
import 'package:taxi_shift_app/application/providers/repositories_provider.dart';
import 'package:taxi_shift_app/data/local/database.dart' hide ShiftPattern;
import 'package:taxi_shift_app/domain/constants/shift_cycle_presets.dart';
import 'package:taxi_shift_app/presentation/screens/onboarding/onboarding_screen.dart';

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

  testWidgets('Onboarding flow test - no end date', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    // Provide a real router to allow context.go('/') to work without error
    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('Home')),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Step 1: Welcome
    expect(find.text('TaxiShift へようこそ'), findsOneWidget);
    await tester.tap(find.text('はじめる'));
    await tester.pumpAndSettle();

    // Step 2: Select Preset
    expect(find.text('サイクル選択'), findsOneWidget);
    final presetName = ShiftCyclePresets.all.first.name;
    await tester.tap(find.text(presetName));
    await tester.pumpAndSettle();
    await tester.tap(find.text('この設定で進む'));
    await tester.pumpAndSettle();

    // Step 3: Set Start Date
    expect(find.text('開始日の設定'), findsOneWidget);

    // Verify change anytime hint exists
    expect(
      find.text('※ 開始日、終了日、サイクルパターンは後から「設定」画面でいつでも変更できます。'),
      findsOneWidget,
    );

    // Complete without setting end date
    await tester.tap(find.text('完了'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);

    final repo = container.read(shiftPatternsRepositoryProvider);
    final patterns = await repo.getAll();
    expect(patterns.length, 1);
    expect(patterns.first.validUntil, isNull);

    // Verify Provider
    final isCompleted = await container.read(
      isOnboardingCompletedProvider.future,
    );
    expect(isCompleted, true);
  });

  testWidgets('Onboarding flow test - with valid end date', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('Home')),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('はじめる'));
    await tester.pumpAndSettle();
    final presetName = ShiftCyclePresets.all.first.name;
    await tester.tap(find.text(presetName));
    await tester.pumpAndSettle();
    await tester.tap(find.text('この設定で進む'));
    await tester.pumpAndSettle();

    // Set End Date
    await tester.tap(find.widgetWithText(ListTile, '終了日'));
    await tester.pumpAndSettle();

    // Pop the DatePickerDialog directly with a selected date to avoid flaky hit tests
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop(DateTime(2030, 12, 31));
    await tester.pumpAndSettle();

    await tester.tap(find.text('完了'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);

    final repo = container.read(shiftPatternsRepositoryProvider);
    final patterns = await repo.getAll();
    expect(patterns.length, 1);
    expect(patterns.first.validUntil, isNotNull);
  });
}
