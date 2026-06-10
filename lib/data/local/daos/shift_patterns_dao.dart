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
