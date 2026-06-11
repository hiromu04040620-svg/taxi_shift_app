import 'package:drift/drift.dart' as drift;

import '../../domain/models/work_session.dart';
import '../../domain/repositories/work_sessions_repository.dart';
import '../local/daos/work_sessions_dao.dart';
import '../local/database.dart' as db;

class WorkSessionsRepositoryImpl implements WorkSessionsRepository {
  final WorkSessionsDao _dao;

  WorkSessionsRepositoryImpl(this._dao);

  @override
  Future<int> create(WorkSession session) async {
    await _validateSession(session);

    // 重複チェック
    final existing = await _dao.findByShiftDate(session.shiftDate);
    if (existing != null) {
      throw ArgumentError('WorkSession for this date already exists');
    }

    final companion = db.WorkSessionsCompanion.insert(
      date: session.shiftDate,
      startTime: session.startDateTime,
      endTime: session.endDateTime,
      breakMinutes: session.restMinutes,
      note: drift.Value(session.note),
    );

    return _dao.insertWorkSession(companion);
  }

  @override
  Future<void> update(WorkSession session) async {
    if (session.id == null) {
      throw ArgumentError('WorkSession ID is required for update');
    }

    await _validateSession(session);

    // 重複チェック (自分自身を除く)
    final existing = await _dao.findByShiftDate(session.shiftDate);
    if (existing != null && existing.id != session.id) {
      throw ArgumentError('WorkSession for this date already exists');
    }

    final companion = db.WorkSessionsCompanion(
      id: drift.Value(session.id!),
      date: drift.Value(session.shiftDate),
      startTime: drift.Value(session.startDateTime),
      endTime: drift.Value(session.endDateTime),
      breakMinutes: drift.Value(session.restMinutes),
      note: drift.Value(session.note),
    );

    await _dao.updateWorkSession(companion);
  }

  @override
  Future<void> delete(int id) async {
    await _dao.deleteWorkSession(id);
  }

  @override
  Future<WorkSession?> findById(int id) async {
    final row = await _dao.findById(id);
    if (row == null) return null;
    return _mapToDomain(row);
  }

  @override
  Future<WorkSession?> findByShiftDate(DateTime date) async {
    final row = await _dao.findByShiftDate(date);
    if (row == null) return null;
    return _mapToDomain(row);
  }

  @override
  Future<List<WorkSession>> findByMonth(int year, int month) async {
    final rows = await _dao.findByMonth(year, month);
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<List<WorkSession>> findInRange(DateTime from, DateTime to) async {
    final rows = await _dao.findInRange(from, to);
    return rows.map(_mapToDomain).toList();
  }

  Future<void> _validateSession(WorkSession session) async {
    if (session.startDateTime.isAfter(session.endDateTime) ||
        session.startDateTime.isAtSameMomentAs(session.endDateTime)) {
      throw ArgumentError('startDateTime must be before endDateTime');
    }

    final durationMinutes = session.endDateTime
        .difference(session.startDateTime)
        .inMinutes;
    if (durationMinutes < 60) {
      throw ArgumentError('Total duration must be at least 1 hour');
    }

    if (session.restMinutes < 0) {
      throw ArgumentError('restMinutes cannot be negative');
    }

    if (session.restMinutes > durationMinutes * 0.8) {
      throw ArgumentError('restMinutes cannot exceed 80% of total duration');
    }
  }

  WorkSession _mapToDomain(db.WorkSession row) {
    return WorkSession(
      id: row.id,
      shiftDate: row.date,
      startDateTime: row.startTime,
      endDateTime: row.endTime,
      restMinutes: row.breakMinutes,
      note: row.note,
    );
  }
}
