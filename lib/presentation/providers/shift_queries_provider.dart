import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/providers/repositories_provider.dart';
import '../../application/providers/services_provider.dart';
import '../../domain/models/shift_pattern.dart';
import '../../domain/models/shift_type.dart';

part 'shift_queries_provider.g.dart';

@riverpod
Future<ShiftPattern?> activeShiftPattern(Ref ref) async {
  final repo = ref.watch(shiftPatternsRepositoryProvider);
  final patterns = await repo.getActive();
  return patterns.isNotEmpty ? patterns.first : null;
}

@riverpod
Future<ShiftType?> shiftTypeForDate(Ref ref, DateTime date) async {
  final service = ref.watch(shiftCycleServiceProvider);
  return service.resolveShiftType(date);
}

@riverpod
Future<Map<DateTime, ShiftType>> shiftsInMonth(
  Ref ref,
  ({int year, int month}) monthArg,
) async {
  final service = ref.watch(shiftCycleServiceProvider);
  final from = DateTime(monthArg.year, monthArg.month);
  final nextMonth = monthArg.month == 12 ? 1 : monthArg.month + 1;
  final nextYear = monthArg.month == 12 ? monthArg.year + 1 : monthArg.year;
  final to = DateTime(nextYear, nextMonth, 0);
  return service.resolveDateRange(from, to);
}
