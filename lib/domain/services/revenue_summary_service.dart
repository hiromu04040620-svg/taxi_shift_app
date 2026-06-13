import 'dart:math';

import '../models/commission_config.dart';
import '../models/commission_result.dart';
import '../models/monthly_summary.dart';
import '../models/revenue.dart';

class RevenueSummaryService {
  MonthlySummary calculateMonthlySummary(List<Revenue> revenues) {
    if (revenues.isEmpty) {
      return const MonthlySummary(
        totalGrossRevenue: 0,
        totalTaxExcludedRevenue: 0,
        averageRevenuePerShift: 0,
        totalShiftsCount: 0,
        totalRidesCount: 0,
        totalDistance: 0,
        totalOccupiedDistance: 0,
        overallOccupancyRate: 0,
        paymentBreakdown: {'cash': 0, 'card': 0, 'app': 0, 'ticket': 0},
      );
    }

    int totalGross = 0;
    int totalTaxExcluded = 0;
    int totalRides = 0;
    double totalDistance = 0;
    double totalOccupied = 0;
    int cash = 0, card = 0, app = 0, ticket = 0;

    for (final r in revenues) {
      totalGross += r.grossRevenue;
      totalTaxExcluded += r.taxExcludedRevenue;
      totalRides += r.ridesCount;
      totalDistance += r.totalDistance;
      totalOccupied += r.occupiedDistance;
      cash += r.cashAmount;
      card += r.cardAmount;
      app += r.appAmount;
      ticket += r.ticketAmount;
    }

    final double avgRevenue = totalGross / revenues.length;
    final double overallOccupancy = totalDistance == 0
        ? 0.0
        : totalOccupied / totalDistance;

    return MonthlySummary(
      totalGrossRevenue: totalGross,
      totalTaxExcludedRevenue: totalTaxExcluded,
      averageRevenuePerShift: avgRevenue,
      totalShiftsCount: revenues.length,
      totalRidesCount: totalRides,
      totalDistance: totalDistance,
      totalOccupiedDistance: totalOccupied,
      overallOccupancyRate: overallOccupancy,
      paymentBreakdown: {
        'cash': cash,
        'card': card,
        'app': app,
        'ticket': ticket,
      },
    );
  }

  CommissionResult calculateCommission(
    MonthlySummary summary,
    CommissionConfig config,
  ) {
    final int excess = max(
      0,
      summary.totalTaxExcludedRevenue - config.ashikiriAmount,
    );
    final int commission = (excess * config.commissionRate).round();
    final bool isAbove =
        summary.totalTaxExcludedRevenue > config.ashikiriAmount;

    return CommissionResult(
      baseRevenue: summary.totalTaxExcludedRevenue,
      excessRevenue: excess,
      commissionAmount: commission,
      isAboveAshikiri: isAbove,
    );
  }
}
