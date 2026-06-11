import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/providers/services_provider.dart';
import '../../domain/models/improvement_warning.dart';
import 'work_session_queries_provider.dart';

part 'improvement_warnings_provider.g.dart';

@riverpod
Future<List<ImprovementWarning>> monthlyWarnings(
  Ref ref,
  ({int year, int month}) monthArg,
) async {
  final sessions = await ref.watch(
    workSessionsInMonthProvider(monthArg).future,
  );
  final service = ref.watch(improvementStandardServiceProvider);
  return service.checkMonthlyTotal(sessions);
}

@riverpod
Future<List<ImprovementWarning>> sessionWarnings(Ref ref, DateTime date) async {
  final current = await ref.watch(workSessionForDateProvider(date).future);
  if (current == null) return [];

  final service = ref.watch(improvementStandardServiceProvider);
  final singleWarnings = service.checkSingleSession(current);

  // 前日のセッションを取得（連続休息期間の判定のため）
  final prevDate = date.subtract(const Duration(days: 1));
  final previous = await ref.watch(workSessionForDateProvider(prevDate).future);

  final consecutiveWarnings = service.checkConsecutiveRest(current, previous);

  return [...singleWarnings, ...consecutiveWarnings];
}
