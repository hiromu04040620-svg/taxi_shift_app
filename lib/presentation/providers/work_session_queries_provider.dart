import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/providers/repositories_provider.dart';
import '../../domain/models/work_session.dart';

part 'work_session_queries_provider.g.dart';

@riverpod
Future<WorkSession?> workSessionForDate(Ref ref, DateTime date) async {
  final repo = ref.watch(workSessionsRepositoryProvider);
  return repo.findByShiftDate(date);
}

@riverpod
Future<List<WorkSession>> workSessionsInMonth(
  Ref ref,
  ({int year, int month}) monthArg,
) async {
  final repo = ref.watch(workSessionsRepositoryProvider);
  return repo.findByMonth(monthArg.year, monthArg.month);
}
