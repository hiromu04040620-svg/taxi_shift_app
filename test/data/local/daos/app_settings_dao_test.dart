import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/data/local/daos/app_settings_dao.dart';
import 'package:taxi_shift_app/data/local/database.dart';

void main() {
  late AppDatabase db;
  late AppSettingsDao dao;

  setUp(() {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    dao = db.appSettingsDao;
  });

  tearDown(() async {
    await db.close();
  });

  test('getSettings returns id=1 record', () async {
    // getSettings should succeed because onCreate inserts the initial row
    final settings = await dao.getSettings();
    expect(settings.id, 1);
    expect(settings.monthlyClosingDay, 15);
  });

  test('updateSettings updates updatedAt field via trigger', () async {
    final initial = await dao.getSettings();
    final firstUpdatedAt = initial.updatedAt;

    await Future<void>.delayed(const Duration(milliseconds: 1000));

    await dao.updateSettings(
      const AppSettingsCompanion(monthlyClosingDay: Value(20)),
    );

    final updated = await dao.getSettings();
    expect(updated.monthlyClosingDay, 20);
    expect(updated.updatedAt.isAfter(firstUpdatedAt), true);
  });

  test('watchSettings emits new values on update', () async {
    final stream = dao.watchSettings();

    // Listen for the first two events: initial state and updated state
    final expectations = expectLater(
      stream.map((s) => s.ashikiriAmount),
      emitsInOrder([0, 50000]),
    );

    // Ensure the stream has time to emit the first value before update
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // Now trigger an update
    await dao.updateSettings(
      const AppSettingsCompanion(ashikiriAmount: Value(50000)),
    );

    await expectations;
  });
}
