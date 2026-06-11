import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'repositories_provider.dart';

part 'onboarding_provider.g.dart';

@Riverpod(keepAlive: true)
Future<bool> isOnboardingCompleted(Ref ref) async {
  final repo = ref.watch(shiftPatternsRepositoryProvider);
  final patterns = await repo.getAll();
  return patterns.isNotEmpty;
}
