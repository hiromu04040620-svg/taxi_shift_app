import 'package:freezed_annotation/freezed_annotation.dart';

part 'commission_result.freezed.dart';

@freezed
abstract class CommissionResult with _$CommissionResult {
  const factory CommissionResult({
    required int baseRevenue,
    required int excessRevenue,
    required int commissionAmount,
    required bool isAboveAshikiri,
  }) = _CommissionResult;
}
