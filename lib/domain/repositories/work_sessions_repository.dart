import '../models/work_session.dart';

abstract class WorkSessionsRepository {
  Future<int> create(WorkSession session);
  Future<void> update(WorkSession session);
  Future<void> delete(int id);
  Future<WorkSession?> findById(int id);
  Future<WorkSession?> findByShiftDate(DateTime date);
  Future<List<WorkSession>> findByMonth(int year, int month);
  Future<List<WorkSession>> findInRange(DateTime from, DateTime to);
}
