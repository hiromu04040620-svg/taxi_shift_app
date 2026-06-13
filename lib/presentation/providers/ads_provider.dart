import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_settings_queries_provider.dart';

part 'ads_provider.g.dart';

@riverpod
class AdsEnabled extends _$AdsEnabled {
  @override
  bool build() {
    final settings = ref.watch(appSettingsProvider).value;
    return settings?.isPremium != true;
  }
}
