import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taxi_shift_app/app.dart';
import 'package:taxi_shift_app/application/providers/database_provider.dart';
import 'package:taxi_shift_app/application/providers/onboarding_provider.dart';
import 'package:taxi_shift_app/data/local/database.dart';
import 'package:taxi_shift_app/domain/models/app_settings.dart';
import 'package:taxi_shift_app/presentation/providers/app_settings_queries_provider.dart';

void main() {
  testWidgets('TaxiShiftApp smoke test', (WidgetTester tester) async {
    final inMemoryDb = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(inMemoryDb.close);

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(inMemoryDb),
        appSettingsProvider.overrideWith(
          (ref) => Stream.value(
            const AppSettings(
              monthlyClosingDay: 20,
              maxMonthlyShifts: 12,
              maxMonthlyRestraintHours: 299,
              ashikiriAmount: 30000,
              commissionRate: 0.6,
              themeMode: ThemeMode.system,
              improvementStandardEnabled: true,
              isPremium: false,
              customLabels: {},
            ),
          ),
        ),
        isOnboardingCompletedProvider.overrideWith((ref) => Future.value(true)),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TaxiShiftApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('カレンダー'), findsWidgets);

    // Note: Theme testing is moved to settings tests.
  });
}
