import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:taxi_shift_app/application/providers/repositories_provider.dart';
import 'package:taxi_shift_app/data/repositories/shift_patterns_repository.dart';
import 'package:taxi_shift_app/domain/models/shift_pattern.dart';
import 'package:taxi_shift_app/domain/models/shift_type.dart';
import 'package:taxi_shift_app/domain/models/work_style.dart';
import 'package:taxi_shift_app/presentation/screens/settings/sections/shift_pattern_settings_section.dart';

class FakeShiftPatternsRepository implements ShiftPatternsRepository {
  final ShiftPattern dummyPattern;

  FakeShiftPatternsRepository(this.dummyPattern);

  @override
  Future<List<ShiftPattern>> getActive() async => [dummyPattern];

  @override
  Future<List<ShiftPattern>> getAll() async => [dummyPattern];

  @override
  Future<ShiftPattern?> getActiveAt(DateTime date) async => dummyPattern;

  @override
  Future<List<ShiftPattern>> getActiveBetween(
    DateTime from,
    DateTime to,
  ) async => [dummyPattern];

  @override
  Future<ShiftPattern> create(ShiftPattern pattern) async => pattern;

  @override
  Future<void> update(ShiftPattern pattern) async {}

  @override
  Future<void> deactivate(int id) async {}

  @override
  Stream<List<ShiftPattern>> watchActive() => Stream.value([dummyPattern]);
}

void main() {
  late FakeShiftPatternsRepository mockRepo;
  late ShiftPattern dummyPattern;

  setUpAll(() async {
    await initializeDateFormatting('ja_JP');
  });

  setUp(() {
    dummyPattern = ShiftPattern(
      id: 1,
      name: '標準（月12出番）',
      workStyle: WorkStyle.dayShift,
      cycle: [ShiftType.workDay, ShiftType.afterDuty, ShiftType.dayOff],
      startDate: DateTime(2026, 6),
      validFrom: DateTime(2026, 6),
      isActive: true,
      createdAt: DateTime(2026, 6),
      updatedAt: DateTime(2026, 6),
    );
    mockRepo = FakeShiftPatternsRepository(dummyPattern);
  });

  Widget buildTestWidget() {
    return ProviderScope(
      overrides: [shiftPatternsRepositoryProvider.overrideWithValue(mockRepo)],
      child: const MaterialApp(
        locale: Locale('ja', 'JP'),
        supportedLocales: [Locale('ja', 'JP')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: ShiftPatternSettingsSection()),
      ),
    );
  }

  testWidgets('セクションが現在のサイクル種別と開始日を表示する', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('シフトパターン'), findsOneWidget);
    expect(find.textContaining('標準（月12出番）'), findsWidgets);
    expect(find.text('開始日を変更'), findsOneWidget);
    expect(find.text('サイクル種別を変更'), findsOneWidget);
  });

  testWidgets('「開始日を変更」タップで DatePicker が開く', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('開始日を変更'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('OK'), findsOneWidget);
  });

  testWidgets('「サイクル種別を変更」タップでプリセット一覧ダイアログが開く', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('サイクル種別を変更'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('サイクル種別を選択'), findsOneWidget);
    expect(find.text('次へ'), findsOneWidget);
  });
}
