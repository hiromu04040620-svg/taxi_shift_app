import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/ad_config.dart';
import '../../core/services/ad_consent_gateway.dart';
import '../../core/services/ad_environment_gateway.dart';

enum AdRuntimeStatus { idle, loading, ready, unavailable }

class AdRuntimeState {
  final AdRuntimeStatus status;
  final String? adUnitId;
  final bool privacyOptionsRequired;
  final String? diagnosticCode;

  const AdRuntimeState({
    required this.status,
    this.adUnitId,
    this.privacyOptionsRequired = false,
    this.diagnosticCode,
  });

  const AdRuntimeState.idle() : this(status: AdRuntimeStatus.idle);
}

final adConsentGatewayProvider = Provider<AdConsentGateway>(
  (ref) => PluginAdConsentGateway(),
);

final adsSdkGatewayProvider = Provider<AdsSdkGateway>(
  (ref) => PluginAdsSdkGateway(),
);

final adEnvironmentGatewayProvider = Provider<AdEnvironmentGateway>(
  (ref) => const MethodChannelAdEnvironmentGateway(),
);

final adRuntimePlatformProvider = Provider<TargetPlatform>(
  (ref) => defaultTargetPlatform,
);

final adRuntimeDebugModeProvider = Provider<bool>((ref) => kDebugMode);

final adRuntimeControllerProvider =
    NotifierProvider<AdRuntimeController, AdRuntimeState>(
      AdRuntimeController.new,
    );

class AdRuntimeController extends Notifier<AdRuntimeState> {
  var _initializationStarted = false;
  var _adsSdkInitialized = false;
  var _disposed = false;

  @override
  AdRuntimeState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(initialize));
    return const AdRuntimeState.idle();
  }

  Future<void> initialize() async {
    if (_initializationStarted) return;
    _initializationStarted = true;
    state = const AdRuntimeState(status: AdRuntimeStatus.loading);

    try {
      final consent = await ref.read(adConsentGatewayProvider).gatherConsent();
      await _applyConsent(consent);
    } catch (error, stackTrace) {
      debugPrint('Ad consent initialization failed: $error\n$stackTrace');
      if (_disposed) return;
      state = const AdRuntimeState(
        status: AdRuntimeStatus.unavailable,
        diagnosticCode: 'ad-consent-failed',
      );
    }
  }

  Future<void> showPrivacyOptions() async {
    if (!state.privacyOptionsRequired) return;

    final previous = state;
    state = AdRuntimeState(
      status: AdRuntimeStatus.loading,
      adUnitId: previous.adUnitId,
      privacyOptionsRequired: true,
      diagnosticCode: previous.diagnosticCode,
    );

    try {
      final consent = await ref
          .read(adConsentGatewayProvider)
          .showPrivacyOptions();
      await _applyConsent(consent);
    } catch (error, stackTrace) {
      debugPrint('Ad privacy options failed: $error\n$stackTrace');
      if (_disposed) return;
      state = AdRuntimeState(
        status: previous.status,
        adUnitId: previous.adUnitId,
        privacyOptionsRequired: previous.privacyOptionsRequired,
        diagnosticCode: 'ad-privacy-failed',
      );
    }
  }

  Future<void> _applyConsent(AdConsentResult consent) async {
    if (_disposed) return;
    if (!consent.canRequestAds) {
      state = AdRuntimeState(
        status: AdRuntimeStatus.unavailable,
        privacyOptionsRequired: consent.privacyOptionsRequired,
        diagnosticCode: consent.diagnosticCode ?? 'ad-consent-required',
      );
      return;
    }

    final environment = await ref.read(adEnvironmentGatewayProvider).current();
    if (_disposed) return;
    final adUnitId = AdConfig.bannerAdUnitId(
      platform: ref.read(adRuntimePlatformProvider),
      isDebug: ref.read(adRuntimeDebugModeProvider),
      environment: environment,
    );
    if (adUnitId == null) {
      state = AdRuntimeState(
        status: AdRuntimeStatus.unavailable,
        privacyOptionsRequired: consent.privacyOptionsRequired,
        diagnosticCode: consent.diagnosticCode ?? 'ad-environment-unsupported',
      );
      return;
    }

    if (!_adsSdkInitialized) {
      await ref.read(adsSdkGatewayProvider).initialize();
      _adsSdkInitialized = true;
    }
    if (_disposed) return;
    state = AdRuntimeState(
      status: AdRuntimeStatus.ready,
      adUnitId: adUnitId,
      privacyOptionsRequired: consent.privacyOptionsRequired,
      diagnosticCode: consent.diagnosticCode,
    );
  }
}
