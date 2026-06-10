import 'package:drift/drift.dart' as drift;

import '../../domain/models/override_status.dart';
import '../../domain/models/shift_override.dart';
import '../../domain/models/shift_type.dart';
import '../local/daos/shift_overrides_dao.dart';
import '../local/database.dart' as db;

abstract class ShiftOverridesRepository {
  Future<List<ShiftOverride>> getAll();
  Future<ShiftOverride?> getByDate(DateTime date);
  Future<List<ShiftOverride>> getBetween(DateTime from, DateTime to);
  Future<ShiftOverride> upsertSingle(ShiftOverride override);
  Future<List<ShiftOverride>> createSwap({
    required DateTime dateA,
    required ShiftType newTypeA,
    required DateTime dateB,
    required ShiftType newTypeB,
    String? reason,
  });
  Future<void> deleteSwap(int overrideId);
  Future<void> deleteSingle(int id);
}

class ShiftOverridesRepositoryImpl implements ShiftOverridesRepository {
  final ShiftOverridesDao _dao;

  ShiftOverridesRepositoryImpl(this._dao);

  @override
  Future<List<ShiftOverride>> getAll() async {
    final rows = await _dao.getAll();
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<ShiftOverride?> getByDate(DateTime date) async {
    final row = await _dao.getByDate(date);
    if (row == null) return null;
    return _mapToDomain(row);
  }

  @override
  Future<List<ShiftOverride>> getBetween(DateTime from, DateTime to) async {
    final rows = await _dao.getBetween(from, to);
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<ShiftOverride> upsertSingle(ShiftOverride override) async {
    final existing = await _dao.getByDate(override.date);

    final companion = db.ShiftOverridesCompanion.insert(
      id: existing != null
          ? drift.Value(existing.id)
          : const drift.Value.absent(),
      date: override.date,
      shiftType: override.shiftType.name,
      status: override.status.name,
      reason: drift.Value(override.reason),
      pairedOverrideId: drift.Value(override.pairedOverrideId),
    );

    await _dao.upsert(companion);
    final saved = await _dao.getByDate(override.date);
    return _mapToDomain(saved!);
  }

  @override
  Future<List<ShiftOverride>> createSwap({
    required DateTime dateA,
    required ShiftType newTypeA,
    required DateTime dateB,
    required ShiftType newTypeB,
    String? reason,
  }) async {
    if (dateA.year == dateB.year &&
        dateA.month == dateB.month &&
        dateA.day == dateB.day) {
      throw ArgumentError('dateA and dateB must be different');
    }

    final results = <ShiftOverride>[];

    await _dao.transactionBlock(() async {
      // Upsert A first without paired ID
      final existingA = await _dao.getByDate(dateA);
      final companionA = db.ShiftOverridesCompanion.insert(
        id: existingA != null
            ? drift.Value(existingA.id)
            : const drift.Value.absent(),
        date: dateA,
        shiftType: newTypeA.name,
        status: OverrideStatus.confirmed.name,
        reason: drift.Value(reason),
      );
      await _dao.upsert(companionA);
      final savedA = (await _dao.getByDate(dateA))!;

      // Upsert B with paired ID = A.id
      final existingB = await _dao.getByDate(dateB);
      final companionB = db.ShiftOverridesCompanion.insert(
        id: existingB != null
            ? drift.Value(existingB.id)
            : const drift.Value.absent(),
        date: dateB,
        shiftType: newTypeB.name,
        status: OverrideStatus.confirmed.name,
        reason: drift.Value(reason),
        pairedOverrideId: drift.Value(savedA.id),
      );
      await _dao.upsert(companionB);
      final savedB = (await _dao.getByDate(dateB))!;

      // Update A with paired ID = B.id
      await _dao.updateOverride(
        db.ShiftOverridesCompanion(
          id: drift.Value(savedA.id),
          pairedOverrideId: drift.Value(savedB.id),
        ),
      );

      final finalA = (await _dao.getByDate(dateA))!;

      results.add(_mapToDomain(finalA));
      results.add(_mapToDomain(savedB));
    });

    return results;
  }

  @override
  Future<void> deleteSwap(int overrideId) async {
    await _dao.transactionBlock(() async {
      final target = await _dao.getById(overrideId);
      if (target == null) return;

      final pairedId = target.pairedOverrideId;
      await _dao.deleteOverride(overrideId);

      if (pairedId != null) {
        await _dao.deleteOverride(pairedId);
      }
    });
  }

  @override
  Future<void> deleteSingle(int id) async {
    await _dao.deleteOverride(id);
  }

  ShiftOverride _mapToDomain(db.ShiftOverride row) {
    OverrideStatus status;
    switch (row.status) {
      case 'requested':
        status = OverrideStatus.requested;
        break;
      case 'confirmed':
      default:
        status = OverrideStatus.confirmed;
        break;
    }

    ShiftType type;
    switch (row.shiftType) {
      case 'afterDuty':
        type = ShiftType.afterDuty;
        break;
      case 'dayOff':
        type = ShiftType.dayOff;
        break;
      case 'extraWork':
        type = ShiftType.extraWork;
        break;
      case 'optionalDayOff':
        type = ShiftType.optionalDayOff;
        break;
      case 'paidLeave':
        type = ShiftType.paidLeave;
        break;
      case 'workDay':
      default:
        type = ShiftType.workDay;
        break;
    }

    return ShiftOverride(
      id: row.id,
      date: row.date,
      shiftType: type,
      status: status,
      reason: row.reason,
      pairedOverrideId: row.pairedOverrideId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
