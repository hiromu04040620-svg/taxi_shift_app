import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/core/services/ad_consent_gateway.dart';
import 'package:taxi_shift_app/core/services/ad_environment_gateway.dart';
import 'package:taxi_shift_app/presentation/providers/ad_runtime_provider.dart';

class _FakeAdConsentGateway implements AdConsentGateway {
  AdConsentResult gatherResult = const AdConsentResult(canRequestAds: true);
  AdConsentResult privacyResult = const AdConsentResult(canRequestAds: true);
  Object? gatherError;
  int gatherCalls = 0;
  int privacyCalls = 0;

  @override
  Future<AdConsentResult> gatherConsent() async {
    gatherCalls += 1;
    if (gatherError case final error?) throw error;
    return gatherResult;
  }

  @override
  Future<AdConsentResult> showPrivacyOptions() async {
    privacyCalls += 1;
    return privacyResult;
  }
}

class _FakeAdsSdkGateway implements AdsSdkGateway {
  int initializeCalls = 0;

  @override
  Future<void> initialize() async {
    initializeCalls += 1;
  }
}

class _FakeAdEnvironmentGateway implements AdEnvironmentGateway {
  AdStoreEnvironment environment = AdStoreEnvironment.sandbox;
  int currentCalls = 0;

  @override
  Future<AdStoreEnvironment> current() async {
    currentCalls += 1;
    return environment;
  }
}

ProviderContainer _createContainer({
  required _FakeAdConsentGateway consent,
  required _FakeAdsSdkGateway adsSdk,
  required _FakeAdEnvironmentGateway environment,
}) {
  return ProviderContainer(
    overrides: [
      adConsentGatewayProvider.overrideWithValue(consent),
      adsSdkGatewayProvider.overrideWithValue(adsSdk),
      adEnvironmentGatewayProvider.overrideWithValue(environment),
      adRuntimePlatformProvider.overrideWithValue(TargetPlatform.iOS),
      adRuntimeDebugModeProvider.overrideWithValue(false),
    ],
  );
}

Future<AdRuntimeState> _waitForStatus(
  ProviderContainer container,
  AdRuntimeStatus expected,
) async {
  final current = container.read(adRuntimeControllerProvider);
  if (current.status == expected) return current;

  final completer = Completer<AdRuntimeState>();
  final subscription = container.listen(adRuntimeControllerProvider, (_, next) {
    if (next.status == expected && !completer.isCompleted) {
      completer.complete(next);
    }
  });
  addTearDown(subscription.close);
  return completer.future.timeout(const Duration(seconds: 2));
}

void main() {
  late _FakeAdConsentGateway consent;
  late _FakeAdsSdkGateway adsSdk;
  late _FakeAdEnvironmentGateway environment;

  setUp(() {
    consent = _FakeAdConsentGateway();
    adsSdk = _FakeAdsSdkGateway();
    environment = _FakeAdEnvironmentGateway();
  });

  test('UMPが広告を許可した時だけ広告利用可能になる', () async {
    consent.gatherResult = const AdConsentResult(
      canRequestAds: true,
      privacyOptionsRequired: true,
    );
    final container = _createContainer(
      consent: consent,
      adsSdk: adsSdk,
      environment: environment,
    );
    addTearDown(container.dispose);

    final state = await _waitForStatus(container, AdRuntimeStatus.ready);

    expect(state.adUnitId, 'ca-app-pub-3940256099942544/2934735716');
    expect(state.privacyOptionsRequired, true);
    expect(adsSdk.initializeCalls, 1);
  });

  test('UMPが広告を許可しない時は広告IDを公開しない', () async {
    consent.gatherResult = const AdConsentResult(canRequestAds: false);
    final container = _createContainer(
      consent: consent,
      adsSdk: adsSdk,
      environment: environment,
    );
    addTearDown(container.dispose);

    final state = await _waitForStatus(container, AdRuntimeStatus.unavailable);

    expect(state.adUnitId, isNull);
    expect(environment.currentCalls, 0);
    expect(adsSdk.initializeCalls, 0);
  });

  test('同意処理が失敗してもアプリを継続し診断コードを保持する', () async {
    consent.gatherError = StateError('consent unavailable');
    final container = _createContainer(
      consent: consent,
      adsSdk: adsSdk,
      environment: environment,
    );
    addTearDown(container.dispose);

    final state = await _waitForStatus(container, AdRuntimeStatus.unavailable);

    expect(state.diagnosticCode, 'ad-consent-failed');
    expect(state.adUnitId, isNull);
  });

  test('初期化を重ねて要求してもSDKは一度だけ初期化する', () async {
    final container = _createContainer(
      consent: consent,
      adsSdk: adsSdk,
      environment: environment,
    );
    addTearDown(container.dispose);

    await _waitForStatus(container, AdRuntimeStatus.ready);
    await container.read(adRuntimeControllerProvider.notifier).initialize();
    await container.read(adRuntimeControllerProvider.notifier).initialize();

    expect(consent.gatherCalls, 1);
    expect(adsSdk.initializeCalls, 1);
  });

  test('プライバシー設定を再表示した後も状態を再評価する', () async {
    consent.gatherResult = const AdConsentResult(
      canRequestAds: true,
      privacyOptionsRequired: true,
    );
    consent.privacyResult = const AdConsentResult(canRequestAds: true);
    final container = _createContainer(
      consent: consent,
      adsSdk: adsSdk,
      environment: environment,
    );
    addTearDown(container.dispose);
    await _waitForStatus(container, AdRuntimeStatus.ready);

    await container
        .read(adRuntimeControllerProvider.notifier)
        .showPrivacyOptions();
    final state = container.read(adRuntimeControllerProvider);

    expect(consent.privacyCalls, 1);
    expect(state.status, AdRuntimeStatus.ready);
    expect(state.privacyOptionsRequired, false);
    expect(adsSdk.initializeCalls, 1);
  });
}
