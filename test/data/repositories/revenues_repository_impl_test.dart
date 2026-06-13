import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/data/local/database.dart' hide Revenue;
import 'package:taxi_shift_app/data/repositories/revenues_repository_impl.dart';
import 'package:taxi_shift_app/domain/models/revenue.dart';

void main() {
  late AppDatabase db;
  late RevenuesRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    await db.customStatement('PRAGMA foreign_keys = ON');
    repository = RevenuesRepositoryImpl(db.revenuesDao);
  });

  tearDown(() async {
    await db.close();
  });

  final validRevenue = Revenue(
    shiftDate: DateTime(2023),
    grossRevenue: 50000,
    taxExcludedRevenue: 45000,
    cashAmount: 20000,
    cardAmount: 15000,
    appAmount: 10000,
    ticketAmount: 5000,
    totalDistance: 200,
    occupiedDistance: 100,
    ridesCount: 20,
  );

  test('正常 create', () async {
    final id = await repository.create(validRevenue);
    expect(id, isPositive);

    final saved = await repository.findById(id);
    expect(saved, isNotNull);
    expect(saved!.shiftDate, validRevenue.shiftDate);
    expect(saved.grossRevenue, 50000);
  });

  test('同日重複でエラー', () async {
    await repository.create(validRevenue);

    final duplicate = validRevenue.copyWith(grossRevenue: 1000);
    expect(() => repository.create(duplicate), throwsArgumentError);
  });

  test('税抜が税込を超えてエラー', () async {
    final invalid = validRevenue.copyWith(taxExcludedRevenue: 60000);
    expect(() => repository.create(invalid), throwsArgumentError);
  });

  test('実車距離が総走行距離を超えてエラー', () async {
    final invalid = validRevenue.copyWith(occupiedDistance: 300);
    expect(() => repository.create(invalid), throwsArgumentError);
  });
}
