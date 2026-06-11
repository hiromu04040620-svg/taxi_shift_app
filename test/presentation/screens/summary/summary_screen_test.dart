import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/core/theme/app_theme.dart';
import 'package:taxi_shift_app/domain/models/app_settings.dart';
import 'package:taxi_shift_app/domain/models/improvement_warning.dart';
import 'package:taxi_shift_app/domain/models/monthly_summary.dart';
import 'package:taxi_shift_app/domain/models/work_session.dart';
import 'package:taxi_shift_app/presentation/providers/app_settings_queries_provider.dart';
import 'package:taxi_shift_app/presentation/providers/improvement_warnings_provider.dart';
import 'package:taxi_shift_app/presentation/providers/revenue_queries_provider.dart';
import 'package:taxi_shift_app/presentation/providers/work_session_queries_provider.dart';
import 'package:taxi_shift_app/presentation/screens/summary/summary_screen.dart';

void main() {
  testWidgets('SummaryScreen shows tabs and tab contents', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          monthlySummaryProvider.overrideWith(
            (ref, arg) => Future.value(
              const MonthlySummary(
                totalGrossRevenue: 10000,
                totalTaxExcludedRevenue: 9000,
                averageRevenuePerShift: 1000,
                totalShiftsCount: 10,
                totalRidesCount: 10,
                totalDistance: 100,
                totalOccupiedDistance: 50,
                overallOccupancyRate: 50,
                paymentBreakdown: {},
              ),
            ),
          ),
          workSessionsInMonthProvider.overrideWith(
            (ref, arg) => Future.value(<WorkSession>[]),
          ),
          monthlyWarningsProvider.overrideWith(
            (ref, arg) => Future.value(<ImprovementWarning>[]),
          ),
          appSettingsProvider.overrideWith(
            (ref) => Stream.value(
              const AppSettings(
                monthlyClosingDay: 20,
                commissionRate: 0.5,
                ashikiriAmount: 300000,
                improvementStandardEnabled: true,
                maxMonthlyRestraintHours: 262,
                maxMonthlyShifts: 13,
                themeMode: ThemeMode.system,
                isPremium: false,
                customLabels: {},
              ),
            ),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const SummaryScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('売上'), findsWidgets);
    expect(find.text('勤務'), findsWidgets);
    expect(find.text('法令'), findsWidgets);
  });
}
