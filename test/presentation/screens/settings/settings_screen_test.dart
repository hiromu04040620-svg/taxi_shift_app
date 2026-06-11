import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/domain/models/app_settings.dart';
import 'package:taxi_shift_app/domain/repositories/app_settings_repository.dart';
import 'package:taxi_shift_app/application/providers/repositories_provider.dart';
import 'package:taxi_shift_app/presentation/screens/settings/settings_screen.dart';

class FakeAppSettingsRepository extends AppSettingsRepository {
  static const defaultSettings = AppSettings(
    monthlyClosingDay: 20,
    maxMonthlyShifts: 12,
    maxMonthlyRestraintHours: 299,
    ashikiriAmount: 30000,
    commissionRate: 0.6,
    themeMode: ThemeMode.system,
    improvementStandardEnabled: true,
    isPremium: false,
    customLabels: {},
  );

  @override
  Future<AppSettings> get() async {
    return defaultSettings;
  }

  @override
  Stream<AppSettings> watch() {
    return Stream.value(defaultSettings);
  }

  // 他のメソッドはテストで呼ばれないので未実装でよい
  @override
  Future<void> updateMonthlyClosingDay(int day) async {}
  @override
  Future<void> updateAshikiriAmount(int amount) async {}
  @override
  Future<void> updateCommissionRate(double rate) async {}
  @override
  Future<void> updateThemeMode(ThemeMode mode) async {}
  @override
  Future<void> updateImprovementStandardEnabled(bool enabled) async {}
  @override
  Future<void> updateMaxMonthlyShifts(int shifts) async {}
  @override
  Future<void> updateMaxMonthlyRestraintHours(int hours) async {}
  @override
  Future<void> deleteAllUserData() async {}
}

void main() {
  late FakeAppSettingsRepository fakeSettingsRepo;

  setUp(() {
    fakeSettingsRepo = FakeAppSettingsRepository();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        appSettingsRepositoryProvider.overrideWithValue(fakeSettingsRepo),
      ],
      child: const MaterialApp(home: SettingsScreen()),
    );
  }

  testWidgets('設定画面の各セクションのタイトルが表示される', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('外観'), findsOneWidget);
    expect(find.text('勤務'), findsOneWidget);
    expect(find.text('売上'), findsOneWidget);
    expect(find.text('シフトパターン'), findsOneWidget);
    expect(find.text('データ管理'), findsOneWidget);
    expect(find.text('アプリ情報'), findsOneWidget);
  });

  testWidgets('AppSettings の初期値が反映されている', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('20日'), findsOneWidget);
    expect(find.text('12出番'), findsOneWidget);
    expect(find.text('299時間'), findsOneWidget);
    expect(find.text('30000円'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
  });

  testWidgets('全データ削除ボタンをタップするとダイアログが表示される', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // スクロールして削除ボタンを表示する
    final scrollable = find.byType(Scrollable);
    final deleteButton = find.text('すべてのデータを削除');

    await tester.scrollUntilVisible(deleteButton, 500, scrollable: scrollable);
    await tester.pumpAndSettle();

    // 削除ボタンをタップ
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // 第1段階の確認ダイアログが表示されるか
    expect(find.text('全データ削除'), findsOneWidget);
    expect(find.textContaining('本当によろしいですか？'), findsOneWidget);
  });
}
