import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:taxi_shift_app/app.dart';
import 'package:taxi_shift_app/application/providers/database_provider.dart';
import 'package:taxi_shift_app/application/providers/repositories_provider.dart';
import 'package:taxi_shift_app/data/local/database.dart' hide ShiftPattern;
import 'package:taxi_shift_app/domain/models/shift_pattern.dart';
import 'package:taxi_shift_app/domain/models/shift_type.dart';
import 'package:taxi_shift_app/domain/models/work_style.dart';

void main() {
  late AppDatabase db;

  setUpAll(() async {
    await initializeDateFormatting('ja_JP');
  });

  setUp(() async {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    await db.customStatement('PRAGMA foreign_keys = ON');
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('CalendarScreen widgets test', (WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final repo = container.read(shiftPatternsRepositoryProvider);
    final pattern = ShiftPattern(
      id: 0,
      name: 'テストパターン',
      workStyle: WorkStyle.alternateDay,
      cycle: [ShiftType.workDay, ShiftType.afterDuty, ShiftType.dayOff],
      startDate: DateTime.now(),
      validFrom: DateTime.now(),
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await repo.create(pattern);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TaxiShiftApp(),
      ),
    );
    await tester.pumpAndSettle();

    final now = DateTime.now();
    final headerTitle = DateFormat('yyyy年 M月', 'ja_JP').format(now);
    expect(find.text(headerTitle), findsOneWidget);

    final dateToTap = DateTime(now.year, now.month, 15);
    final dateLabel = DateFormat('yyyy年M月d日 (E)', 'ja_JP').format(dateToTap);

    // table_calendar usually has multiple elements with text "15" (e.g. from previous/next months) if they bleed over
    // Find the one that is currently active inside the calendar
    await tester.tap(find.text('15').first);
    await tester.pumpAndSettle();

    expect(find.text(dateLabel), findsOneWidget);

    final todayLabel = DateFormat('yyyy年M月d日 (E)', 'ja_JP').format(now);
    await tester.tap(find.byIcon(Icons.today));
    await tester.pumpAndSettle();

    expect(find.text(todayLabel), findsOneWidget);
  });
}
