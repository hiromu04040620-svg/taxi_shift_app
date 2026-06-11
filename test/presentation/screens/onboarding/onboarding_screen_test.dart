import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
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

  testWidgets('Onboarding flow test', (WidgetTester tester) async {
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
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    // Step 1: Welcome
    expect(find.text('TaxiShift へようこそ'), findsOneWidget);
    await tester.tap(find.text('はじめる'));
    await tester.pumpAndSettle();

    // Step 2: Select Preset
    expect(find.text('サイクル選択'), findsOneWidget);

    // Tap the first preset
    final presetName = ShiftCyclePresets.all.first.name;
    await tester.tap(find.text(presetName));
    await tester.pumpAndSettle();

    // Proceed
    await tester.tap(find.text('この設定で進む'));
    await tester.pumpAndSettle();

    // Step 3: Set Start Date
    expect(find.text('開始日の設定'), findsOneWidget);

    // Complete
    await tester.tap(find.text('完了'));
    await tester.pumpAndSettle();

    // Now it should have navigated to '/'
    expect(find.text('Home'), findsOneWidget);

    // Verify DB
    final repo = container.read(shiftPatternsRepositoryProvider);
    final patterns = await repo.getAll();
    expect(patterns.length, 1);
    expect(patterns.first.name, presetName);

    // Verify Provider
    final isCompleted = await container.read(
      isOnboardingCompletedProvider.future,
    );
    expect(isCompleted, true);
  });
}
