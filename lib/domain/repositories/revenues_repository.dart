import '../models/revenue.dart';

abstract class RevenuesRepository {
  Future<int> create(Revenue revenue);
  Future<void> update(Revenue revenue);
  Future<void> delete(int id);
  Future<Revenue?> findById(int id);
  Future<Revenue?> findByShiftDate(DateTime date);
  Future<List<Revenue>> findByMonth(int year, int month);
  Future<List<Revenue>> findInRange(DateTime from, DateTime to);
  Future<void> linkToWorkSession(int revenueId, int workSessionId);
}
