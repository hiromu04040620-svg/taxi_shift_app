import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/data/local/daos/shift_patterns_dao.dart';
import 'package:taxi_shift_app/data/local/database.dart';

void main() {
  late AppDatabase db;
  late ShiftPatternsDao dao;

  setUp(() {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    dao = db.shiftPatternsDao;
  });

  tearDown(() async {
    await db.close();
  });

  test('CRUD operations', () async {
    final companion = ShiftPatternsCompanion.insert(
      name: 'A班',
      workStyle: 'alternateDay',
      cycle: '["workDay","afterDuty","dayOff"]',
      startDate: DateTime(2023),
      validFrom: DateTime(2023),
      isActive: true,
    );

    final id = await dao.insert(companion);
    expect(id, isNotNull);

    final item = await dao.getById(id);
    expect(item, isNotNull);
    expect(item!.name, 'A班');

    await dao.updatePattern(
      ShiftPatternsCompanion(id: Value(id), name: const Value('A班(更新)')),
    );

    final updated = await dao.getById(id);
    expect(updated!.name, 'A班(更新)');

    await dao.deactivate(id);
    final deactivated = await dao.getById(id);
    expect(deactivated!.isActive, false);
  });

  test(
    'getActiveAt returns correct pattern based on date boundaries',
    () async {
      final id1 = await dao.insert(
        ShiftPatternsCompanion.insert(
          name: 'Pattern 1',
          workStyle: 'alternateDay',
          cycle: '[]',
          startDate: DateTime(2023),
          validFrom: DateTime(2023),
          validUntil: Value(DateTime(2023, 12, 31)),
          isActive: true,
        ),
      );

      final id2 = await dao.insert(
        ShiftPatternsCompanion.insert(
          name: 'Pattern 2',
          workStyle: 'alternateDay',
          cycle: '[]',
          startDate: DateTime(2024),
          validFrom: DateTime(2024),
          validUntil: const Value(null),
          isActive: true,
        ),
      );

      // Within Pattern 1
      var p = await dao.getActiveAt(DateTime(2023, 5, 5));
      expect(p?.id, id1);

      // Exactly validFrom
      p = await dao.getActiveAt(DateTime(2023));
      expect(p?.id, id1);

      // Exactly validUntil
      p = await dao.getActiveAt(DateTime(2023, 12, 31));
      expect(p?.id, id1);

      // After validUntil, before validFrom of Pattern 2
      p = await dao.getActiveAt(DateTime(2023, 12, 31, 23, 59, 59));
      // Since we use DateOnlyConverter, 2023-12-31 should still match Pattern 1
      expect(p?.id, id1);

      p = await dao.getActiveAt(DateTime(2024));
      expect(p?.id, id2);

      p = await dao.getActiveAt(DateTime(2025));
      expect(p?.id, id2);
    },
  );
}
