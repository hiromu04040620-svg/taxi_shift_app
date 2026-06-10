import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/data/local/database.dart' hide ShiftOverride;
import 'package:taxi_shift_app/data/repositories/shift_overrides_repository.dart';
import 'package:taxi_shift_app/domain/models/shift_override.dart';
import 'package:taxi_shift_app/domain/models/shift_type.dart';

void main() {
  late AppDatabase db;
  late ShiftOverridesRepository repository;

  setUp(() async {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    // Enable PRAGMA explicitly for tests
    await db.customStatement('PRAGMA foreign_keys = ON');
    repository = ShiftOverridesRepositoryImpl(db.shiftOverridesDao);
  });

  tearDown(() async {
    await db.close();
  });

  test('upsertSingle updates existing record by date', () async {
    final override1 = ShiftOverride(
      id: 0,
      date: DateTime(2023),
      shiftType: ShiftType.workDay,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final saved1 = await repository.upsertSingle(override1);
    expect(saved1.id, isPositive);

    final override2 = override1.copyWith(
      shiftType: ShiftType.dayOff,
      reason: 'Sick leave',
    );

    final saved2 = await repository.upsertSingle(override2);
    expect(saved2.id, saved1.id); // Must be the same ID
    expect(saved2.shiftType, ShiftType.dayOff);
    expect(saved2.reason, 'Sick leave');
  });

  test('createSwap validates same day', () async {
    expect(
      () => repository.createSwap(
        dateA: DateTime(2023),
        newTypeA: ShiftType.dayOff,
        dateB: DateTime(2023),
        newTypeB: ShiftType.workDay,
      ),
      throwsArgumentError,
    );
  });

  test('createSwap creates two linked records', () async {
    final results = await repository.createSwap(
      dateA: DateTime(2023),
      newTypeA: ShiftType.dayOff,
      dateB: DateTime(2023, 1, 2),
      newTypeB: ShiftType.workDay,
      reason: 'Swap days',
    );

    expect(results.length, 2);
    expect(results[0].pairedOverrideId, results[1].id);
    expect(results[1].pairedOverrideId, results[0].id);

    // Verify in DB
    final a = await repository.getByDate(DateTime(2023));
    final b = await repository.getByDate(DateTime(2023, 1, 2));

    expect(a!.pairedOverrideId, b!.id);
    expect(b.pairedOverrideId, a.id);
  });

  test('deleteSwap deletes both paired records', () async {
    final results = await repository.createSwap(
      dateA: DateTime(2023),
      newTypeA: ShiftType.dayOff,
      dateB: DateTime(2023, 1, 2),
      newTypeB: ShiftType.workDay,
    );

    await repository.deleteSwap(results[0].id);

    final a = await repository.getByDate(DateTime(2023));
    final b = await repository.getByDate(DateTime(2023, 1, 2));

    expect(a, isNull);
    expect(b, isNull);
  });

  test('deleteSingle nullifies pairedOverrideId of partner', () async {
    final results = await repository.createSwap(
      dateA: DateTime(2023),
      newTypeA: ShiftType.dayOff,
      dateB: DateTime(2023, 1, 2),
      newTypeB: ShiftType.workDay,
    );

    // Delete just A via deleteSingle
    await repository.deleteSingle(results[0].id);

    final a = await repository.getByDate(DateTime(2023));
    final b = await repository.getByDate(DateTime(2023, 1, 2));

    expect(a, isNull);
    expect(b, isNotNull);
    expect(b!.pairedOverrideId, isNull);
  });
}
