import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaywallPromptSession {
  bool hasShown = false;

  void markShown() {
    hasShown = true;
  }
}

final paywallPromptSessionProvider = Provider<PaywallPromptSession>(
  (ref) => PaywallPromptSession(),
);
