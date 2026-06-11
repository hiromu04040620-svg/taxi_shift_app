import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_summary.freezed.dart';

@freezed
abstract class MonthlySummary with _$MonthlySummary {
  const factory MonthlySummary({
    required int totalGrossRevenue,
    required int totalTaxExcludedRevenue,
    required double averageRevenuePerShift,
    required int totalShiftsCount,
    required int totalRidesCount,
    required double totalDistance,
    required double totalOccupiedDistance,
    required double overallOccupancyRate,
    required Map<String, int> paymentBreakdown,
  }) = _MonthlySummary;
}
