import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/domain/models/revenue.dart';

void main() {
  final baseRevenue = Revenue(
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

  group('Revenue calculations', () {
    test('occupancyRate calculates correctly', () {
      expect(baseRevenue.occupancyRate, 0.5);
    });

    test('occupancyRate avoids zero division', () {
      final rev = baseRevenue.copyWith(totalDistance: 0);
      expect(rev.occupancyRate, 0.0);
    });

    test('averageRevenuePerRide calculates correctly', () {
      expect(baseRevenue.averageRevenuePerRide, 2500.0);
    });

    test('averageRevenuePerRide avoids zero division', () {
      final rev = baseRevenue.copyWith(ridesCount: 0);
      expect(rev.averageRevenuePerRide, 0.0);
    });

    test('paymentBreakdownSum calculates correctly', () {
      expect(baseRevenue.paymentBreakdownSum, 50000);
    });
  });
}
