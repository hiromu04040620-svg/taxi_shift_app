import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/data/local/database.dart' hide WorkSession;
import 'package:taxi_shift_app/data/repositories/work_sessions_repository_impl.dart';
import 'package:taxi_shift_app/domain/models/work_session.dart';

void main() {
  late AppDatabase db;
  late WorkSessionsRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    await db.customStatement('PRAGMA foreign_keys = ON');
    repository = WorkSessionsRepositoryImpl(db.workSessionsDao);
  });

  tearDown(() async {
    await db.close();
  });

  final validSession = WorkSession(
    shiftDate: DateTime(2023),
    startDateTime: DateTime(2023, 1, 1, 8),
    endDateTime: DateTime(2023, 1, 2, 4), // 20 hours
    restMinutes: 180,
    note: 'Test note',
  );

  test('正常 create', () async {
    final id = await repository.create(validSession);
    expect(id, isPositive);

    final saved = await repository.findById(id);
    expect(saved, isNotNull);
    expect(saved!.shiftDate, validSession.shiftDate);
    expect(saved.note, 'Test note');
  });

  test('同日重複でエラー', () async {
    await repository.create(validSession);

    final duplicate = validSession.copyWith(restMinutes: 60);
    expect(() => repository.create(duplicate), throwsArgumentError);
  });

  test('startDateTime >= endDateTime でエラー', () async {
    final invalid = validSession.copyWith(
      startDateTime: DateTime(2023, 1, 1, 8),
      endDateTime: DateTime(2023, 1, 1, 8),
    );
    expect(() => repository.create(invalid), throwsArgumentError);
  });

  test('restMinutes が拘束時間超過でエラー (80%超)', () async {
    final invalid = validSession.copyWith(
      restMinutes: 20 * 60, // 20 hours rest
    );
    expect(() => repository.create(invalid), throwsArgumentError);
  });
}
