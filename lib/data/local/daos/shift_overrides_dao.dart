import 'package:drift/drift.dart';

import '../converters/date_only_converter.dart';
import '../database.dart';
import '../tables/shift_overrides.dart' as tbl;

part 'shift_overrides_dao.g.dart';

@DriftAccessor(tables: [tbl.ShiftOverrides])
class ShiftOverridesDao extends DatabaseAccessor<AppDatabase>
    with _$ShiftOverridesDaoMixin {
  ShiftOverridesDao(super.db);

  Future<List<ShiftOverride>> getAll() => select(shiftOverrides).get();

  Future<ShiftOverride?> getById(int id) =>
      (select(shiftOverrides)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<ShiftOverride?> getByDate(DateTime date) {
    final dateStr = const DateOnlyConverter().toSql(date);
    return (select(
      shiftOverrides,
    )..where((t) => t.date.equals(dateStr))).getSingleOrNull();
  }

  Future<List<ShiftOverride>> getBetween(DateTime from, DateTime to) {
    final fromStr = const DateOnlyConverter().toSql(from);
    final toStr = const DateOnlyConverter().toSql(to);
    return (select(shiftOverrides)
          ..where((t) => t.date.isBiggerOrEqualValue(fromStr))
          ..where((t) => t.date.isSmallerOrEqualValue(toStr)))
        .get();
  }

  Future<int> insertOverride(ShiftOverridesCompanion companion) =>
      into(shiftOverrides).insert(companion);

  Future<int> updateOverride(ShiftOverridesCompanion companion) => (update(
    shiftOverrides,
  )..where((t) => t.id.equals(companion.id.value))).write(companion);

  Future<int> upsert(ShiftOverridesCompanion companion) {
    return into(shiftOverrides).insertOnConflictUpdate(companion);
  }

  Future<void> deleteOverride(int id) =>
      (delete(shiftOverrides)..where((t) => t.id.equals(id))).go();

  Future<void> transactionBlock(Future<void> Function() action) =>
      transaction(action);
}
