// ignore_for_file: avoid_redundant_argument_values
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/data/repositories/shift_overrides_repository.dart';
import 'package:taxi_shift_app/data/repositories/shift_patterns_repository.dart';
import 'package:taxi_shift_app/domain/models/override_status.dart';
import 'package:taxi_shift_app/domain/models/shift_override.dart';
import 'package:taxi_shift_app/domain/models/shift_pattern.dart';
import 'package:taxi_shift_app/domain/models/shift_type.dart';
import 'package:taxi_shift_app/domain/models/work_style.dart';
import 'package:taxi_shift_app/domain/services/shift_cycle_service.dart';

class FakeShiftPatternsRepository implements ShiftPatternsRepository {
  ShiftPattern? activeAtReturn;
  List<ShiftPattern> activeBetweenReturn = [];

  @override
  Future<ShiftPattern> create(ShiftPattern pattern) =>
      throw UnimplementedError();
  @override
  Future<void> deactivate(int id) => throw UnimplementedError();
  @override
  Future<List<ShiftPattern>> getActive() => throw UnimplementedError();
  @override
  Future<ShiftPattern?> getActiveAt(DateTime date) async => activeAtReturn;
  @override
  Future<List<ShiftPattern>> getActiveBetween(
    DateTime from,
    DateTime to,
  ) async => activeBetweenReturn;
  @override
  Future<List<ShiftPattern>> getAll() => throw UnimplementedError();
  @override
  Future<void> update(ShiftPattern pattern) => throw UnimplementedError();
  @override
  Stream<List<ShiftPattern>> watchActive() => throw UnimplementedError();
}

class FakeShiftOverridesRepository implements ShiftOverridesRepository {
  ShiftOverride? byDateReturn;
  List<ShiftOverride> betweenReturn = [];

  @override
  Future<List<ShiftOverride>> createSwap({
    required DateTime dateA,
    required ShiftType newTypeA,
    required DateTime dateB,
    required ShiftType newTypeB,
    String? reason,
  }) => throw UnimplementedError();
  @override
  Future<void> deleteSingle(int id) => throw UnimplementedError();
  @override
  Future<void> deleteSwap(int overrideId) => throw UnimplementedError();
  @override
  Future<List<ShiftOverride>> getAll() => throw UnimplementedError();
  @override
  Future<List<ShiftOverride>> getBetween(DateTime from, DateTime to) async =>
      betweenReturn;
  @override
  Future<ShiftOverride?> getByDate(DateTime date) async => byDateReturn;
  @override
  Future<ShiftOverride> upsertSingle(ShiftOverride override) =>
      throw UnimplementedError();
}

void main() {
  late FakeShiftPatternsRepository fakePatternsRepo;
  late FakeShiftOverridesRepository fakeOverridesRepo;
  late ShiftCycleService service;

  setUp(() {
    fakePatternsRepo = FakeShiftPatternsRepository();
    fakeOverridesRepo = FakeShiftOverridesRepository();
    service = ShiftCycleServiceImpl(fakePatternsRepo, fakeOverridesRepo);
  });

  final defaultPattern = ShiftPattern(
    id: 1,
    name: 'A班',
    workStyle: WorkStyle.alternateDay,
    cycle: [ShiftType.workDay, ShiftType.afterDuty, ShiftType.dayOff],
    startDate: DateTime(2023),
    validFrom: DateTime(2023),
    validUntil: null,
    isActive: true,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  test('resolveByPattern returns correct sequence', () async {
    expect(
      await service.resolveByPattern(defaultPattern, DateTime(2023)),
      ShiftType.workDay,
    );
    expect(
      await service.resolveByPattern(defaultPattern, DateTime(2023, 1, 2)),
      ShiftType.afterDuty,
    );
    expect(
      await service.resolveByPattern(defaultPattern, DateTime(2023, 1, 3)),
      ShiftType.dayOff,
    );
    expect(
      await service.resolveByPattern(defaultPattern, DateTime(2023, 1, 4)),
      ShiftType.workDay,
    );
  });

  test('resolveByPattern returns null before startDate', () async {
    expect(
      await service.resolveByPattern(defaultPattern, DateTime(2022, 12, 31)),
      isNull,
    );
  });

  test('resolveByPattern returns null outside valid date range', () async {
    final pattern = defaultPattern.copyWith(validUntil: DateTime(2023, 1, 31));
    expect(await service.resolveByPattern(pattern, DateTime(2023, 2)), isNull);
  });

  test('resolveByPattern returns null if isActive is false', () async {
    final pattern = defaultPattern.copyWith(isActive: false);
    expect(await service.resolveByPattern(pattern, DateTime(2023)), isNull);
  });

  test('resolveByPattern handles cycle of length 1', () async {
    final pattern = defaultPattern.copyWith(cycle: [ShiftType.workDay]);
    expect(
      await service.resolveByPattern(pattern, DateTime(2023)),
      ShiftType.workDay,
    );
    expect(
      await service.resolveByPattern(pattern, DateTime(2023, 1, 10)),
      ShiftType.workDay,
    );
  });

  test('resolveByPattern returns null if cycle is empty', () async {
    final pattern = defaultPattern.copyWith(cycle: []);
    expect(await service.resolveByPattern(pattern, DateTime(2023)), isNull);
  });

  test('resolveShiftType prioritizes override over pattern', () async {
    fakeOverridesRepo.byDateReturn = ShiftOverride(
      id: 1,
      date: DateTime(2023),
      shiftType: ShiftType.extraWork,
      status: OverrideStatus.confirmed,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    fakePatternsRepo.activeAtReturn = defaultPattern;

    final type = await service.resolveShiftType(DateTime(2023));
    expect(type, ShiftType.extraWork);
  });

  test('resolveShiftType falls back to pattern if no override', () async {
    fakeOverridesRepo.byDateReturn = null;
    fakePatternsRepo.activeAtReturn = defaultPattern;

    final type = await service.resolveShiftType(DateTime(2023));
    expect(type, ShiftType.workDay);
  });

  test('resolveShiftType returns null if neither', () async {
    fakeOverridesRepo.byDateReturn = null;
    fakePatternsRepo.activeAtReturn = null;

    final type = await service.resolveShiftType(DateTime(2023));
    expect(type, isNull);
  });

  test('resolveDateRange works over long range boundaries', () async {
    fakeOverridesRepo.betweenReturn = [];
    fakePatternsRepo.activeBetweenReturn = [defaultPattern];

    final range = await service.resolveDateRange(
      DateTime(2023),
      DateTime(2023),
    );
    expect(range.length, 1);
    expect(range[DateTime(2023)], ShiftType.workDay);
  });
}
