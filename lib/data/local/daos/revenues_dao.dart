import 'package:drift/drift.dart';

import '../converters/date_only_converter.dart';
import '../database.dart';
import '../tables/revenues.dart' as tbl;

part 'revenues_dao.g.dart';

@DriftAccessor(tables: [tbl.Revenues])
class RevenuesDao extends DatabaseAccessor<AppDatabase>
    with _$RevenuesDaoMixin {
  RevenuesDao(super.db);

  Future<int> insertRevenue(RevenuesCompanion companion) =>
      into(revenues).insert(companion);

  Future<bool> updateRevenue(RevenuesCompanion companion) =>
      update(revenues).replace(companion);

  Future<int> deleteRevenue(int id) =>
      (delete(revenues)..where((t) => t.id.equals(id))).go();

  Future<Revenue?> findById(int id) =>
      (select(revenues)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Revenue?> findByShiftDate(DateTime date) {
    final dateStr = const DateOnlyConverter().toSql(date);
    return (select(
      revenues,
    )..where((t) => t.date.equals(dateStr))).getSingleOrNull();
  }

  Future<List<Revenue>> findByMonth(int year, int month) {
    final startStr = const DateOnlyConverter().toSql(DateTime(year, month));
    final nextMonth = month == 12 ? 1 : month + 1;
    final nextYear = month == 12 ? year + 1 : year;
    final endStr = const DateOnlyConverter().toSql(
      DateTime(nextYear, nextMonth).subtract(const Duration(days: 1)),
    );

    return (select(revenues)
          ..where((t) => t.date.isBiggerOrEqualValue(startStr))
          ..where((t) => t.date.isSmallerOrEqualValue(endStr))
          ..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .get();
  }

  Future<List<Revenue>> findInRange(DateTime from, DateTime to) {
    final fromStr = const DateOnlyConverter().toSql(from);
    final toStr = const DateOnlyConverter().toSql(to);

    return (select(revenues)
          ..where((t) => t.date.isBiggerOrEqualValue(fromStr))
          ..where((t) => t.date.isSmallerOrEqualValue(toStr))
          ..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .get();
  }
}
