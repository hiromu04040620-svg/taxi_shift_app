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

    // 過去方向への無限展開をサポートするため、期間絞り込みではなくアクティブな全パターンを取得する
    final patterns = await _patternsRepository.getActive();
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

    // validFromより前をnullにする制限を撤廃（_findActivePattern側で過去への適用を許容しているため）
    if (pattern.validUntil != null) {
      final validUntil = _dateOnly(pattern.validUntil!);
      if (target.isAfter(validUntil)) return null;
    }

    final daysDiff = target.difference(start).inDays;
    final cycleIndex = daysDiff % pattern.cycle.length;

    return pattern.cycle[cycleIndex];
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  ShiftPattern? _findActivePattern(List<ShiftPattern> patterns, DateTime date) {
    if (patterns.isEmpty) return null;

    final target = _dateOnly(date);

    // validFrom の古い順にソート
    final sorted = List<ShiftPattern>.from(patterns)
      ..sort((a, b) => a.validFrom.compareTo(b.validFrom));

    for (final p in sorted) {
      final validFrom = _dateOnly(p.validFrom);
      final validUntil = p.validUntil != null ? _dateOnly(p.validUntil!) : null;

      if (!target.isBefore(validFrom) &&
          (validUntil == null || !target.isAfter(validUntil))) {
        return p;
      }
    }

    // どのパターンにも該当しなかった場合（＝最も古いパターンの validFrom より前の場合）、
    // 起点日から過去方向へサイクルを無限展開するために、最も古いパターンを返す。
    final oldest = sorted.first;
    if (target.isBefore(_dateOnly(oldest.validFrom))) {
      return oldest;
    }

    return null;
  }
}
