import '../../data/repositories/shift_overrides_repository.dart';
import '../../data/repositories/shift_patterns_repository.dart';
import '../models/shift_pattern.dart';
import '../models/shift_type.dart';

abstract class ShiftCycleService {
  Future<ShiftType?> resolveShiftType(DateTime date);
  Future<Map<DateTime, ShiftType>> resolveDateRange(DateTime from, DateTime to);
  Future<ShiftType?> resolveByPattern(ShiftPattern pattern, DateTime date);
}

class ShiftCycleServiceImpl implements ShiftCycleService {
  final ShiftPatternsRepository _patternsRepository;
  final ShiftOverridesRepository _overridesRepository;

  ShiftCycleServiceImpl(this._patternsRepository, this._overridesRepository);

  @override
  Future<ShiftType?> resolveShiftType(DateTime date) async {
    // 1. ShiftOverride
    final override = await _overridesRepository.getByDate(date);
    if (override != null) {
      return override.shiftType;
    }

    // 2. ShiftPattern
    final pattern = await _patternsRepository.getActiveAt(date);
    if (pattern != null) {
      return await resolveByPattern(pattern, date);
    }

    return null;
  }

  @override
  Future<Map<DateTime, ShiftType>> resolveDateRange(
    DateTime from,
    DateTime to,
  ) async {
    final result = <DateTime, ShiftType>{};
    if (from.isAfter(to)) return result;

    // パフォーマンスのため一括取得
    final patterns = await _patternsRepository.getActiveBetween(from, to);
    final overrides = await _overridesRepository.getBetween(from, to);

    final overridesMap = {
      for (final o in overrides) _dateOnly(o.date): o.shiftType,
    };

    var current = _dateOnly(from);
    final end = _dateOnly(to);

    while (!current.isAfter(end)) {
      if (overridesMap.containsKey(current)) {
        result[current] = overridesMap[current]!;
      } else {
        // パターンから検索
        final activePattern = _findActivePattern(patterns, current);
        if (activePattern != null) {
          final type = await resolveByPattern(activePattern, current);
          if (type != null) {
            result[current] = type;
          }
        }
      }
      current = current.add(const Duration(days: 1));
    }

    return result;
  }

  @override
  Future<ShiftType?> resolveByPattern(
    ShiftPattern pattern,
    DateTime date,
  ) async {
    if (!pattern.isActive) return null;
    if (pattern.cycle.isEmpty) return null;

    final target = _dateOnly(date);
    final start = _dateOnly(pattern.startDate);

    // validity check
    final validFrom = _dateOnly(pattern.validFrom);
    if (target.isBefore(validFrom)) return null;

    if (pattern.validUntil != null) {
      final validUntil = _dateOnly(pattern.validUntil!);
      if (target.isAfter(validUntil)) return null;
    }

    if (target.isBefore(start)) return null;

    final daysDiff = target.difference(start).inDays;
    final cycleIndex = daysDiff % pattern.cycle.length;

    return pattern.cycle[cycleIndex];
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  ShiftPattern? _findActivePattern(List<ShiftPattern> patterns, DateTime date) {
    final target = _dateOnly(date);
    for (final p in patterns) {
      final validFrom = _dateOnly(p.validFrom);
      final validUntil = p.validUntil != null ? _dateOnly(p.validUntil!) : null;

      if (!target.isBefore(validFrom) &&
          (validUntil == null || !target.isAfter(validUntil))) {
        return p;
      }
    }
    return null;
  }
}
