import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/config/premium_config.dart';
import 'app_settings_queries_provider.dart';

part 'ads_provider.g.dart';

@riverpod
class AdsEnabled extends _$AdsEnabled {
  @override
  bool build() {
    if (!PremiumConfig.monetizationEnabled) {
      return false;
    }

    final settings = ref.watch(appSettingsProvider).value;
    return settings?.isPremium != true;
  }
}
