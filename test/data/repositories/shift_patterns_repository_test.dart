import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/data/local/database.dart' hide ShiftPattern;
import 'package:taxi_shift_app/data/repositories/shift_patterns_repository.dart';
import 'package:taxi_shift_app/domain/models/shift_pattern.dart';
import 'package:taxi_shift_app/domain/models/shift_type.dart';
import 'package:taxi_shift_app/domain/models/work_style.dart';

void main() {
  late AppDatabase db;
  late ShiftPatternsRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    repository = ShiftPatternsRepositoryImpl(db.shiftPatternsDao);
  });

  tearDown(() async {
    await db.close();
  });

  test('create throws on invalid name', () async {
    final pattern = ShiftPattern(
      id: 0,
      name: '  ',
      workStyle: WorkStyle.alternateDay,
      cycle: const [ShiftType.workDay],
      startDate: DateTime(2023),
      validFrom: DateTime(2023),
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    expect(() => repository.create(pattern), throwsArgumentError);
  });

  test('create throws on empty cycle', () async {
    final pattern = ShiftPattern(
      id: 0,
      name: 'A班',
      workStyle: WorkStyle.alternateDay,
      cycle: const <ShiftType>[],
      startDate: DateTime(2023),
      validFrom: DateTime(2023),
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    expect(() => repository.create(pattern), throwsArgumentError);
  });

  test('create throws when validUntil <= validFrom', () async {
    final pattern = ShiftPattern(
      id: 0,
      name: 'A班',
      workStyle: WorkStyle.alternateDay,
      cycle: const [ShiftType.workDay],
      startDate: DateTime(2023, 1, 2),
      validFrom: DateTime(2023, 1, 2),
      validUntil: DateTime(2023),
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    expect(() => repository.create(pattern), throwsArgumentError);
  });

  test('overlap check blocks overlapping active patterns', () async {
    final p1 = ShiftPattern(
      id: 0,
      name: 'Pattern 1',
      workStyle: WorkStyle.alternateDay,
      cycle: const [ShiftType.workDay],
      startDate: DateTime(2023),
      validFrom: DateTime(2023),
      validUntil: DateTime(2023, 1, 31),
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await repository.create(p1);

    // Total overlap
    final p2 = p1.copyWith(
      name: 'Pattern 2',
      validFrom: DateTime(2023, 1, 15),
      validUntil: DateTime(2023, 2, 15),
    );
    expect(() => repository.create(p2), throwsStateError);

    // Exact boundary overlap
    final p3 = p1.copyWith(
      name: 'Pattern 3',
      validFrom: DateTime(2023, 1, 31),
      validUntil: DateTime(2023, 2, 28),
    );
    expect(() => repository.create(p3), throwsStateError);

    // No overlap
    final p4 = p1.copyWith(
      name: 'Pattern 4',
      validFrom: DateTime(2023, 2),
      validUntil: DateTime(2023, 2, 28),
    );
    final created = await repository.create(p4);
    expect(created.id, isPositive);
  });
}
