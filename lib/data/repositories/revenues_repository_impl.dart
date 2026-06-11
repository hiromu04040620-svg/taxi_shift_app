import 'package:drift/drift.dart' as drift;

import '../../domain/models/revenue.dart';
import '../../domain/repositories/revenues_repository.dart';
import '../local/daos/revenues_dao.dart';
import '../local/database.dart' as db;

class RevenuesRepositoryImpl implements RevenuesRepository {
  final RevenuesDao _dao;

  RevenuesRepositoryImpl(this._dao);

  @override
  Future<int> create(Revenue revenue) async {
    await _validateRevenue(revenue);

    // 重複チェック
    final existing = await _dao.findByShiftDate(revenue.shiftDate);
    if (existing != null) {
      throw ArgumentError('Revenue for this date already exists');
    }

    final companion = _createCompanion(revenue);
    return _dao.insertRevenue(companion);
  }

  @override
  Future<void> update(Revenue revenue) async {
    if (revenue.id == null) {
      throw ArgumentError('Revenue ID is required for update');
    }

    await _validateRevenue(revenue);

    // 重複チェック (自分自身を除く)
    final existing = await _dao.findByShiftDate(revenue.shiftDate);
    if (existing != null && existing.id != revenue.id) {
      throw ArgumentError('Revenue for this date already exists');
    }

    final companion = _createCompanion(
      revenue,
    ).copyWith(id: drift.Value(revenue.id!));
    await _dao.updateRevenue(companion);
  }

  @override
  Future<void> delete(int id) async {
    await _dao.deleteRevenue(id);
  }

  @override
  Future<Revenue?> findById(int id) async {
    final row = await _dao.findById(id);
    if (row == null) return null;
    return _mapToDomain(row);
  }

  @override
  Future<Revenue?> findByShiftDate(DateTime date) async {
    final row = await _dao.findByShiftDate(date);
    if (row == null) return null;
    return _mapToDomain(row);
  }

  @override
  Future<List<Revenue>> findByMonth(int year, int month) async {
    final rows = await _dao.findByMonth(year, month);
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<List<Revenue>> findInRange(DateTime from, DateTime to) async {
    final rows = await _dao.findInRange(from, to);
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<void> linkToWorkSession(int revenueId, int workSessionId) async {
    final companion = db.RevenuesCompanion(
      id: drift.Value(revenueId),
      workSessionId: drift.Value(workSessionId),
    );
    await _dao.updateRevenue(companion);
  }

  Future<void> _validateRevenue(Revenue revenue) async {
    if (revenue.grossRevenue < 0) {
      throw ArgumentError('grossRevenue cannot be negative');
    }
    if (revenue.taxExcludedRevenue < 0) {
      throw ArgumentError('taxExcludedRevenue cannot be negative');
    }
    if (revenue.taxExcludedRevenue > revenue.grossRevenue) {
      throw ArgumentError('taxExcludedRevenue cannot exceed grossRevenue');
    }
    if (revenue.cashAmount < 0 ||
        revenue.cardAmount < 0 ||
        revenue.appAmount < 0 ||
        revenue.ticketAmount < 0) {
      throw ArgumentError('Payment breakdown amounts cannot be negative');
    }

    final paymentSum = revenue.paymentBreakdownSum;
    if ((paymentSum - revenue.grossRevenue).abs() > 100) {
      throw ArgumentError(
        'paymentBreakdownSum must be within 100 of grossRevenue',
      );
    }

    if (revenue.totalDistance < 0) {
      throw ArgumentError('totalDistance cannot be negative');
    }
    if (revenue.occupiedDistance < 0) {
      throw ArgumentError('occupiedDistance cannot be negative');
    }
    if (revenue.occupiedDistance > revenue.totalDistance) {
      throw ArgumentError('occupiedDistance cannot exceed totalDistance');
    }
    if (revenue.ridesCount < 0) {
      throw ArgumentError('ridesCount cannot be negative');
    }
    if (revenue.fuelAmount != null && revenue.fuelAmount! < 0) {
      throw ArgumentError('fuelAmount cannot be negative');
    }
  }

  db.RevenuesCompanion _createCompanion(Revenue revenue) {
    return db.RevenuesCompanion.insert(
      date: revenue.shiftDate,
      workSessionId: drift.Value(revenue.workSessionId),
      grossRevenue: revenue.grossRevenue,
      taxExcludedRevenue: revenue.taxExcludedRevenue,
      cashAmount: revenue.cashAmount,
      cardAmount: revenue.cardAmount,
      appAmount: revenue.appAmount,
      ticketAmount: revenue.ticketAmount,
      totalDistance: revenue.totalDistance,
      occupiedDistance: revenue.occupiedDistance,
      ridesCount: revenue.ridesCount,
      fuelAmount: drift.Value(revenue.fuelAmount),
      note: drift.Value(revenue.note),
    );
  }

  Revenue _mapToDomain(db.Revenue row) {
    return Revenue(
      id: row.id,
      shiftDate: row.date,
      workSessionId: row.workSessionId,
      grossRevenue: row.grossRevenue,
      taxExcludedRevenue: row.taxExcludedRevenue,
      cashAmount: row.cashAmount,
      cardAmount: row.cardAmount,
      appAmount: row.appAmount,
      ticketAmount: row.ticketAmount,
      totalDistance: row.totalDistance,
      occupiedDistance: row.occupiedDistance,
      ridesCount: row.ridesCount,
      fuelAmount: row.fuelAmount,
      note: row.note,
    );
  }
}
