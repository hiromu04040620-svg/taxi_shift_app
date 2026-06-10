import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/data/local/daos/shift_overrides_dao.dart';
import 'package:taxi_shift_app/data/local/database.dart';

void main() {
  late AppDatabase db;
  late ShiftOverridesDao dao;

  setUp(() {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    dao = db.shiftOverridesDao;
  });

  tearDown(() async {
    await db.close();
  });

  test('upsert handles insert and update', () async {
    final companion = ShiftOverridesCompanion.insert(
      date: DateTime(2023),
      shiftType: 'workDay',
      status: 'confirmed',
    );

    await dao.upsert(companion);
    var item = await dao.getByDate(DateTime(2023));
    expect(item, isNotNull);
    expect(item!.shiftType, 'workDay');

    final updatedCompanion = ShiftOverridesCompanion.insert(
      id: Value(item.id),
      date: DateTime(2023),
      shiftType: 'dayOff',
      status: 'confirmed',
    );
    await dao.upsert(updatedCompanion);

    item = await dao.getByDate(DateTime(2023));
    expect(item!.shiftType, 'dayOff');
  });

  test('transactionBlock runs actions', () async {
    await dao.transactionBlock(() async {
      await dao.upsert(
        ShiftOverridesCompanion.insert(
          date: DateTime(2023, 1, 2),
          shiftType: 'workDay',
          status: 'confirmed',
        ),
      );
    });

    final item = await dao.getByDate(DateTime(2023, 1, 2));
    expect(item, isNotNull);
  });
}
