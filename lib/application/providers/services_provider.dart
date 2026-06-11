import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/services/improvement_standard_service.dart';
import '../../domain/services/revenue_summary_service.dart';
import '../../domain/services/shift_cycle_service.dart';
import 'repositories_provider.dart';

part 'services_provider.g.dart';

@Riverpod(keepAlive: true)
ShiftCycleService shiftCycleService(Ref ref) {
  return ShiftCycleServiceImpl(
    ref.watch(shiftPatternsRepositoryProvider),
    ref.watch(shiftOverridesRepositoryProvider),
  );
}

@Riverpod(keepAlive: true)
ImprovementStandardService improvementStandardService(Ref ref) {
  return ImprovementStandardService();
}

@Riverpod(keepAlive: true)
RevenueSummaryService revenueSummaryService(Ref ref) {
  return RevenueSummaryService();
}
