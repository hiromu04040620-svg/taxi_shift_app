import 'package:freezed_annotation/freezed_annotation.dart';

import 'override_status.dart';
import 'shift_type.dart';

part 'shift_override.freezed.dart';

@freezed
abstract class ShiftOverride with _$ShiftOverride {
  const factory ShiftOverride({
    required int id,
    required DateTime date,
    required ShiftType shiftType,
    @Default(OverrideStatus.confirmed) OverrideStatus status,
    String? reason,
    int? pairedOverrideId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ShiftOverride;
}
