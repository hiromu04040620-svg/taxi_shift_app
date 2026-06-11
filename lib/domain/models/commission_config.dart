import 'package:freezed_annotation/freezed_annotation.dart';

part 'commission_config.freezed.dart';

@freezed
abstract class CommissionConfig with _$CommissionConfig {
  const factory CommissionConfig({
    required int ashikiriAmount,
    required double commissionRate,
  }) = _CommissionConfig;
}
