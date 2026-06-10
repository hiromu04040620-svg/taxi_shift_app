import 'dart:convert';
import 'package:drift/drift.dart' as drift;

import '../../domain/models/shift_pattern.dart';
import '../../domain/models/shift_type.dart';
import '../../domain/models/work_style.dart';
import '../local/daos/shift_patterns_dao.dart';
import '../local/database.dart' as db;

abstract class ShiftPatternsRepository {
  Future<List<ShiftPattern>> getAll();
  Future<List<ShiftPattern>> getActive();
  Future<ShiftPattern?> getActiveAt(DateTime date);
  Future<ShiftPattern> create(ShiftPattern pattern);
  Future<void> update(ShiftPattern pattern);
  Future<void> deactivate(int id);
  Stream<List<ShiftPattern>> watchActive();
}

class ShiftPatternsRepositoryImpl implements ShiftPatternsRepository {
  final ShiftPatternsDao _dao;

  ShiftPatternsRepositoryImpl(this._dao);

  @override
  Future<List<ShiftPattern>> getAll() async {
    final rows = await _dao.getAll();
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<List<ShiftPattern>> getActive() async {
    final rows = await _dao.getActive();
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<ShiftPattern?> getActiveAt(DateTime date) async {
    final row = await _dao.getActiveAt(date);
    if (row == null) return null;
    return _mapToDomain(row);
  }

  @override
  Future<ShiftPattern> create(ShiftPattern pattern) async {
    _validatePattern(pattern);
    await _checkOverlap(pattern, null);

    final id = await _dao.insert(
      db.ShiftPatternsCompanion.insert(
        name: pattern.name.trim(),
        workStyle: pattern.workStyle.name,
        cycle: jsonEncode(pattern.cycle.map((e) => e.name).toList()),
        startDate: pattern.startDate,
        validFrom: pattern.validFrom,
        validUntil: drift.Value(pattern.validUntil),
        isActive: pattern.isActive,
      ),
    );

    return pattern.copyWith(id: id);
  }

  @override
  Future<void> update(ShiftPattern pattern) async {
    _validatePattern(pattern);
    await _checkOverlap(pattern, pattern.id);

    await _dao.updatePattern(
      db.ShiftPatternsCompanion(
        id: drift.Value(pattern.id),
        name: drift.Value(pattern.name.trim()),
        workStyle: drift.Value(pattern.workStyle.name),
        cycle: drift.Value(
          jsonEncode(pattern.cycle.map((e) => e.name).toList()),
        ),
        startDate: drift.Value(pattern.startDate),
        validFrom: drift.Value(pattern.validFrom),
        validUntil: drift.Value(pattern.validUntil),
        isActive: drift.Value(pattern.isActive),
      ),
    );
  }

  @override
  Future<void> deactivate(int id) async {
    await _dao.deactivate(id);
  }

  @override
  Stream<List<ShiftPattern>> watchActive() {
    return _dao.watchActive().map((rows) => rows.map(_mapToDomain).toList());
  }

  void _validatePattern(ShiftPattern pattern) {
    if (pattern.name.trim().isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    if (pattern.cycle.isEmpty) {
      throw ArgumentError('Cycle cannot be empty');
    }
    if (pattern.validUntil != null &&
        !pattern.validFrom.isBefore(pattern.validUntil!)) {
      throw ArgumentError('validFrom must be before validUntil');
    }
  }

  Future<void> _checkOverlap(ShiftPattern pattern, int? ignoreId) async {
    if (!pattern.isActive) return;

    final activePatterns = await _dao.getActive();
    for (final existing in activePatterns) {
      if (existing.id == ignoreId) continue;

      final overlaps = _doesOverlap(
        pattern.validFrom,
        pattern.validUntil,
        existing.validFrom,
        existing.validUntil,
      );

      if (overlaps) {
        throw StateError(
          'Active shift pattern overlaps with existing pattern (ID: ${existing.id})',
        );
      }
    }
  }

  bool _doesOverlap(
    DateTime startA,
    DateTime? endA,
    DateTime startB,
    DateTime? endB,
  ) {
    final aEndsAfterBStarts = endA == null || !endA.isBefore(startB);
    final aStartsBeforeBEnds = endB == null || !startA.isAfter(endB);

    return aStartsBeforeBEnds && aEndsAfterBStarts;
  }

  ShiftPattern _mapToDomain(db.ShiftPattern row) {
    WorkStyle style;
    switch (row.workStyle) {
      case 'alternateDay':
        style = WorkStyle.alternateDay;
        break;
      case 'nightShift':
        style = WorkStyle.nightShift;
        break;
      case 'dayShift':
      default:
        style = WorkStyle.dayShift;
        break;
    }

    List<ShiftType> cycle = [];
    try {
      final decoded = jsonDecode(row.cycle);
      if (decoded is List) {
        cycle = decoded.map((e) {
          switch (e.toString()) {
            case 'afterDuty':
              return ShiftType.afterDuty;
            case 'dayOff':
              return ShiftType.dayOff;
            case 'workDay':
            default:
              return ShiftType.workDay;
          }
        }).toList();
      }
    } catch (_) {
      // empty or default
    }

    return ShiftPattern(
      id: row.id,
      name: row.name,
      workStyle: style,
      cycle: cycle,
      startDate: row.startDate,
      validFrom: row.validFrom,
      validUntil: row.validUntil,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
