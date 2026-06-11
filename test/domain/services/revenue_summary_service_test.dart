import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/domain/models/commission_config.dart';
import 'package:taxi_shift_app/domain/models/revenue.dart';
import 'package:taxi_shift_app/domain/services/revenue_summary_service.dart';

void main() {
  late RevenueSummaryService service;

  setUp(() {
    service = RevenueSummaryService();
  });

  final rev1 = Revenue(
    id: 1,
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
    id: 2,
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

  group('calculateMonthlySummary', () {
    test('returns zero-initialized summary for empty list', () {
      final summary = service.calculateMonthlySummary([]);
      expect(summary.totalGrossRevenue, 0);
      expect(summary.totalShiftsCount, 0);
    });

    test('calculates correct summary from list', () {
      final summary = service.calculateMonthlySummary([rev1, rev2]);
      expect(summary.totalGrossRevenue, 90000);
      expect(summary.totalTaxExcludedRevenue, 81000);
      expect(summary.averageRevenuePerShift, 45000.0);
      expect(summary.totalShiftsCount, 2);
      expect(summary.totalRidesCount, 35);
      expect(summary.totalDistance, 350.0);
      expect(summary.totalOccupiedDistance, 190.0);
      expect(summary.overallOccupancyRate, 190.0 / 350.0);
      expect(summary.paymentBreakdown['cash'], 30000);
    });
  });

  group('calculateCommission', () {
    test('未達 (excess 0)', () {
      final summary = service.calculateMonthlySummary([rev1]);
      // tax excluded: 45000
      final config = const CommissionConfig(
        ashikiriAmount: 50000,
        commissionRate: 0.5,
      );
      final result = service.calculateCommission(summary, config);

      expect(result.excessRevenue, 0);
      expect(result.commissionAmount, 0);
      expect(result.isAboveAshikiri, isFalse);
    });

    test('超過 (excess positive)', () {
      final summary = service.calculateMonthlySummary([rev1, rev2]);
      // tax excluded: 81000
      final config = const CommissionConfig(
        ashikiriAmount: 50000,
        commissionRate: 0.5,
      );
      final result = service.calculateCommission(summary, config);

      expect(result.excessRevenue, 31000);
      expect(result.commissionAmount, 15500);
      expect(result.isAboveAshikiri, isTrue);
    });

    test('ちょうど (excess 0)', () {
      final summary = service.calculateMonthlySummary([rev1]);
      // tax excluded: 45000
      final config = const CommissionConfig(
        ashikiriAmount: 45000,
        commissionRate: 0.5,
      );
      final result = service.calculateCommission(summary, config);

      expect(result.excessRevenue, 0);
      expect(result.commissionAmount, 0);
      expect(result.isAboveAshikiri, isFalse);
    });
  });
}
