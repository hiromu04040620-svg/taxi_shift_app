import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ads_provider.g.dart';

@riverpod
class AdsEnabled extends _$AdsEnabled {
  @override
  bool build() => true;
}
