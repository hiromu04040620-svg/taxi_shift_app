import 'package:freezed_annotation/freezed_annotation.dart';

import 'shift_type.dart';
import 'work_style.dart';

part 'shift_pattern.freezed.dart';

@freezed
abstract class ShiftPattern with _$ShiftPattern {
  const factory ShiftPattern({
    required int id,
    required String name,
    required WorkStyle workStyle,
    required List<ShiftType> cycle,
    required DateTime startDate,
    required DateTime validFrom,
    DateTime? validUntil,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ShiftPattern;
}
