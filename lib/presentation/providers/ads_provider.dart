import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/config/premium_config.dart';
import 'ad_runtime_provider.dart';
import 'app_settings_queries_provider.dart';

part 'ads_provider.g.dart';

@riverpod
class AdsEnabled extends _$AdsEnabled {
  @override
  bool build() {
    if (!PremiumConfig.monetizationEnabled) {
      return false;
    }

    final settings = ref.watch(appSettingsProvider);
    return settings.maybeWhen(
      data: (value) {
        final runtime = ref.watch(adRuntimeControllerProvider);
        return value.isPremium != true &&
            runtime.status == AdRuntimeStatus.ready &&
            runtime.adUnitId != null;
      },
      orElse: () => false,
    );
  }
}
