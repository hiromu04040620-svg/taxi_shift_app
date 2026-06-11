import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/providers/repositories_provider.dart';
import '../../domain/models/app_settings.dart';

part 'app_settings_queries_provider.g.dart';

@riverpod
Stream<AppSettings> appSettings(Ref ref) {
  final repo = ref.watch(appSettingsRepositoryProvider);
  return repo.watch();
}
