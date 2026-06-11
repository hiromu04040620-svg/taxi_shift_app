import 'package:drift/drift.dart';

import '../converters/date_only_converter.dart';
import '../database.dart';
import '../tables/work_sessions.dart' as tbl;

part 'work_sessions_dao.g.dart';

@DriftAccessor(tables: [tbl.WorkSessions])
class WorkSessionsDao extends DatabaseAccessor<AppDatabase>
    with _$WorkSessionsDaoMixin {
  WorkSessionsDao(super.db);

  Future<int> insertWorkSession(WorkSessionsCompanion companion) =>
      into(workSessions).insert(companion);

  Future<bool> updateWorkSession(WorkSessionsCompanion companion) =>
      update(workSessions).replace(companion);

  Future<int> deleteWorkSession(int id) =>
      (delete(workSessions)..where((t) => t.id.equals(id))).go();

  Future<WorkSession?> findById(int id) =>
      (select(workSessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<WorkSession?> findByShiftDate(DateTime date) {
    final dateStr = const DateOnlyConverter().toSql(date);
    return (select(
      workSessions,
    )..where((t) => t.date.equals(dateStr))).getSingleOrNull();
  }

  Future<List<WorkSession>> findByMonth(int year, int month) {
    final startStr = const DateOnlyConverter().toSql(DateTime(year, month));
    final nextMonth = month == 12 ? 1 : month + 1;
    final nextYear = month == 12 ? year + 1 : year;
    final endStr = const DateOnlyConverter().toSql(
      DateTime(nextYear, nextMonth).subtract(const Duration(days: 1)),
    );

    return (select(workSessions)
          ..where((t) => t.date.isBiggerOrEqualValue(startStr))
          ..where((t) => t.date.isSmallerOrEqualValue(endStr))
          ..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .get();
  }

  Future<List<WorkSession>> findInRange(DateTime from, DateTime to) {
    final fromStr = const DateOnlyConverter().toSql(from);
    final toStr = const DateOnlyConverter().toSql(to);

    return (select(workSessions)
          ..where((t) => t.date.isBiggerOrEqualValue(fromStr))
          ..where((t) => t.date.isSmallerOrEqualValue(toStr))
          ..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .get();
  }
}
