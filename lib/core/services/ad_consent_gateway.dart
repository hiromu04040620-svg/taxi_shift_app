import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdConsentResult {
  final bool canRequestAds;
  final bool privacyOptionsRequired;
  final String? diagnosticCode;

  const AdConsentResult({
    required this.canRequestAds,
    this.privacyOptionsRequired = false,
    this.diagnosticCode,
  });
}

abstract interface class AdConsentGateway {
  Future<AdConsentResult> gatherConsent();

  Future<AdConsentResult> showPrivacyOptions();
}

abstract interface class AdsSdkGateway {
  Future<void> initialize();
}

class PluginAdsSdkGateway implements AdsSdkGateway {
  @override
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }
}

class PluginAdConsentGateway implements AdConsentGateway {
  final ConsentInformation _consentInformation;

  PluginAdConsentGateway({ConsentInformation? consentInformation})
    : _consentInformation = consentInformation ?? ConsentInformation.instance;

  @override
  Future<AdConsentResult> gatherConsent() async {
    String? diagnosticCode;
    final updateError = await _requestConsentInfoUpdate();

    if (updateError == null) {
      final formError = await _loadAndShowConsentFormIfRequired();
      if (formError != null) {
        diagnosticCode = 'ump-form-${formError.errorCode}';
        debugPrint(
          'Ad consent form failed '
          '(${formError.errorCode}): ${formError.message}',
        );
      }
    } else {
      diagnosticCode = 'ump-update-${updateError.errorCode}';
      debugPrint(
        'Ad consent update failed '
        '(${updateError.errorCode}): ${updateError.message}',
      );
    }

    final result = await _currentResult(diagnosticCode: diagnosticCode);
    if (result.canRequestAds) {
      final trackingDiagnostic = await _requestTrackingIfNeeded();
      if (trackingDiagnostic != null) {
        return AdConsentResult(
          canRequestAds: true,
          privacyOptionsRequired: result.privacyOptionsRequired,
          diagnosticCode: trackingDiagnostic,
        );
      }
    }
    return result;
  }

  @override
  Future<AdConsentResult> showPrivacyOptions() async {
    FormError? formError;
    await ConsentForm.showPrivacyOptionsForm((error) {
      formError = error;
    });
    if (formError != null) {
      debugPrint(
        'Ad privacy options failed '
        '(${formError!.errorCode}): ${formError!.message}',
      );
    }
    return _currentResult(
      diagnosticCode: formError == null
          ? null
          : 'ump-privacy-${formError!.errorCode}',
    );
  }

  Future<FormError?> _requestConsentInfoUpdate() {
    final completer = Completer<FormError?>();
    _consentInformation.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () => completer.complete(),
      completer.complete,
    );
    return completer.future;
  }

  Future<FormError?> _loadAndShowConsentFormIfRequired() async {
    FormError? formError;
    await ConsentForm.loadAndShowConsentFormIfRequired((error) {
      formError = error;
    });
    return formError;
  }

  Future<AdConsentResult> _currentResult({String? diagnosticCode}) async {
    final canRequestAds = await _consentInformation.canRequestAds();
    final privacyStatus = await _consentInformation
        .getPrivacyOptionsRequirementStatus();
    return AdConsentResult(
      canRequestAds: canRequestAds,
      privacyOptionsRequired:
          privacyStatus == PrivacyOptionsRequirementStatus.required,
      diagnosticCode: diagnosticCode,
    );
  }

  Future<String?> _requestTrackingIfNeeded() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return null;

    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
      return null;
    } on PlatformException catch (error) {
      debugPrint('ATT request failed (${error.code}): ${error.message}');
      return 'att-${error.code}';
    }
  }
}
