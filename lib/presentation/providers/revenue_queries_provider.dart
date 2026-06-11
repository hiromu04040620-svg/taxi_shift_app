import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/providers/repositories_provider.dart';
import '../../application/providers/services_provider.dart';
import '../../domain/models/monthly_summary.dart';
import '../../domain/models/revenue.dart';

part 'revenue_queries_provider.g.dart';

@riverpod
Future<Revenue?> revenueForDate(Ref ref, DateTime date) async {
  final repo = ref.watch(revenuesRepositoryProvider);
  return repo.findByShiftDate(date);
}

@riverpod
Future<List<Revenue>> revenuesInMonth(
  Ref ref,
  ({int year, int month}) monthArg,
) async {
  final repo = ref.watch(revenuesRepositoryProvider);
  return repo.findByMonth(monthArg.year, monthArg.month);
}

@riverpod
Future<MonthlySummary> monthlySummary(
  Ref ref,
  ({int year, int month}) monthArg,
) async {
  final revenues = await ref.watch(revenuesInMonthProvider(monthArg).future);
  final service = ref.watch(revenueSummaryServiceProvider);
  return service.calculateMonthlySummary(revenues);
}
