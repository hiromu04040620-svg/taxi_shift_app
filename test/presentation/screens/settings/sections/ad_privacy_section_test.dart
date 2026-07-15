import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/presentation/providers/ad_runtime_provider.dart';
import 'package:taxi_shift_app/presentation/screens/settings/sections/ad_privacy_section.dart';

class _FakeAdRuntimeController extends AdRuntimeController {
  final AdRuntimeState initialState;
  int privacyCalls = 0;

  _FakeAdRuntimeController(this.initialState);

  @override
  AdRuntimeState build() => initialState;

  @override
  Future<void> showPrivacyOptions() async {
    privacyCalls += 1;
  }
}

void main() {
  testWidgets('UMPが要求する場合だけ広告プライバシー設定を開ける', (tester) async {
    final controller = _FakeAdRuntimeController(
      const AdRuntimeState(
        status: AdRuntimeStatus.ready,
        adUnitId: 'test-banner',
        privacyOptionsRequired: true,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [adRuntimeControllerProvider.overrideWith(() => controller)],
        child: const MaterialApp(home: Scaffold(body: AdPrivacySection())),
      ),
    );

    expect(find.text('広告のプライバシー設定'), findsOneWidget);
    await tester.tap(find.text('広告のプライバシー設定'));
    await tester.pump();
    expect(controller.privacyCalls, 1);
  });

  testWidgets('UMPが不要な場合は設定項目を表示しない', (tester) async {
    final controller = _FakeAdRuntimeController(
      const AdRuntimeState(status: AdRuntimeStatus.ready),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [adRuntimeControllerProvider.overrideWith(() => controller)],
        child: const MaterialApp(home: Scaffold(body: AdPrivacySection())),
      ),
    );

    expect(find.text('広告のプライバシー設定'), findsNothing);
  });
}
