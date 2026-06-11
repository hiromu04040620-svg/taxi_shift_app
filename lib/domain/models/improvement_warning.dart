import 'package:freezed_annotation/freezed_annotation.dart';

part 'improvement_warning.freezed.dart';

enum WarningLevel { info, warning, critical }

@freezed
abstract class ImprovementWarning with _$ImprovementWarning {
  const factory ImprovementWarning({
    required WarningLevel level,
    required String code,
    required String message,
    DateTime? targetDate,
  }) = _ImprovementWarning;
}
