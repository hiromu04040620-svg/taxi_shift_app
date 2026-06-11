import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/app_settings_repository_impl.dart';
import '../../data/repositories/revenues_repository_impl.dart';
import '../../data/repositories/shift_overrides_repository.dart';
import '../../data/repositories/shift_patterns_repository.dart';
import '../../data/repositories/work_sessions_repository_impl.dart';
import '../../domain/repositories/app_settings_repository.dart';
import '../../domain/repositories/revenues_repository.dart';
import '../../domain/repositories/work_sessions_repository.dart';
import 'database_provider.dart';

part 'repositories_provider.g.dart';

@Riverpod(keepAlive: true)
ShiftPatternsRepository shiftPatternsRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ShiftPatternsRepositoryImpl(db.shiftPatternsDao);
}

@Riverpod(keepAlive: true)
ShiftOverridesRepository shiftOverridesRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ShiftOverridesRepositoryImpl(db.shiftOverridesDao);
}

@Riverpod(keepAlive: true)
WorkSessionsRepository workSessionsRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return WorkSessionsRepositoryImpl(db.workSessionsDao);
}

@Riverpod(keepAlive: true)
RevenuesRepository revenuesRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return RevenuesRepositoryImpl(db.revenuesDao);
}

@Riverpod(keepAlive: true)
AppSettingsRepository appSettingsRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return AppSettingsRepositoryImpl(db);
}
