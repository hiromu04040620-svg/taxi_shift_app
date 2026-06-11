import 'package:freezed_annotation/freezed_annotation.dart';

part 'revenue.freezed.dart';

@freezed
abstract class Revenue with _$Revenue {
  const Revenue._();

  const factory Revenue({
    int? id,
    required DateTime shiftDate,
    int? workSessionId,
    required int grossRevenue,
    required int taxExcludedRevenue,
    required int cashAmount,
    required int cardAmount,
    required int appAmount,
    required int ticketAmount,
    required double totalDistance,
    required double occupiedDistance,
    required int ridesCount,
    int? fuelAmount,
    String? note,
  }) = _Revenue;

  double get occupancyRate =>
      totalDistance == 0 ? 0.0 : occupiedDistance / totalDistance;

  double get averageRevenuePerRide =>
      ridesCount == 0 ? 0.0 : grossRevenue / ridesCount;

  int get paymentBreakdownSum =>
      cashAmount + cardAmount + appAmount + ticketAmount;
}
