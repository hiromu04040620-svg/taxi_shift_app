import 'package:drift/drift.dart';

import '../converters/date_only_converter.dart';
import '../database.dart';
import '../tables/shift_patterns.dart' as tbl;

part 'shift_patterns_dao.g.dart';

@DriftAccessor(tables: [tbl.ShiftPatterns])
class ShiftPatternsDao extends DatabaseAccessor<AppDatabase>
    with _$ShiftPatternsDaoMixin {
  ShiftPatternsDao(super.db);

  Future<List<ShiftPattern>> getAll() => select(shiftPatterns).get();

  Future<List<ShiftPattern>> getActive() =>
      (select(shiftPatterns)..where((t) => t.isActive.equals(true))).get();

  Future<ShiftPattern?> getById(int id) =>
      (select(shiftPatterns)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<ShiftPattern?> getActiveAt(DateTime date) {
    final dateStr = const DateOnlyConverter().toSql(date);
    return (select(shiftPatterns)
          ..where((t) => t.isActive.equals(true))
          ..where((t) => t.validFrom.isSmallerOrEqualValue(dateStr))
          ..where(
            (t) =>
                t.validUntil.isNull() |
                t.validUntil.isBiggerOrEqualValue(dateStr),
          ))
        .getSingleOrNull();
  }

  Future<List<ShiftPattern>> getActiveBetween(DateTime from, DateTime to) {
    final fromStr = const DateOnlyConverter().toSql(from);
    final toStr = const DateOnlyConverter().toSql(to);
    return (select(shiftPatterns)
          ..where((t) => t.isActive.equals(true))
          ..where((t) => t.validFrom.isSmallerOrEqualValue(toStr))
          ..where(
            (t) =>
                t.validUntil.isNull() |
                t.validUntil.isBiggerOrEqualValue(fromStr),
          ))
        .get();
  }

  Future<int> insert(ShiftPatternsCompanion companion) =>
      into(shiftPatterns).insert(companion);

  Future<int> updatePattern(ShiftPatternsCompanion companion) => (update(
    shiftPatterns,
  )..where((t) => t.id.equals(companion.id.value))).write(companion);

  Future<int> deactivate(int id) =>
      (update(shiftPatterns)..where((t) => t.id.equals(id))).write(
        const ShiftPatternsCompanion(isActive: Value(false)),
      );

  Stream<List<ShiftPattern>> watchActive() =>
      (select(shiftPatterns)..where((t) => t.isActive.equals(true))).watch();
}
