import '../models/improvement_warning.dart';
import '../models/work_session.dart';

class ImprovementStandardService {
  List<ImprovementWarning> checkSingleSession(WorkSession session) {
    final warnings = <ImprovementWarning>[];
    final hours = session.totalDurationMinutes / 60.0;

    if (hours > 24.0) {
      warnings.add(
        ImprovementWarning(
          level: WarningLevel.critical,
          code: 'KAIKETSU_24H_OVER',
          message: '1回の拘束時間が24時間を超えています。',
          targetDate: session.shiftDate,
        ),
      );
    } else if (hours > 21.0) {
      warnings.add(
        ImprovementWarning(
          level: WarningLevel.warning,
          code: 'KAIKETSU_21H_OVER',
          message: '1回の拘束時間が21時間を超えています。',
          targetDate: session.shiftDate,
        ),
      );
    }

    return warnings;
  }

  List<ImprovementWarning> checkConsecutiveRest(
    WorkSession current,
    WorkSession? previous,
  ) {
    if (previous == null) return [];

    final warnings = <ImprovementWarning>[];
    final restMinutes = current.startDateTime
        .difference(previous.endDateTime)
        .inMinutes;
    final restHours = restMinutes / 60.0;

    if (restHours < 20.0) {
      warnings.add(
        ImprovementWarning(
          level: WarningLevel.warning,
          code: 'CONSECUTIVE_REST_UNDER_20H',
          message: '連続休息期間が20時間未満です。',
          targetDate: current.shiftDate,
        ),
      );
    }

    return warnings;
  }

  List<ImprovementWarning> checkMonthlyTotal(List<WorkSession> sessions) {
    if (sessions.isEmpty) return [];

    final warnings = <ImprovementWarning>[];
    int totalMinutes = 0;
    for (final s in sessions) {
      totalMinutes += s.totalDurationMinutes;
    }

    final totalHours = totalMinutes / 60.0;
    final targetDate = sessions.first.shiftDate;

    if (totalHours > 270.0) {
      warnings.add(
        ImprovementWarning(
          level: WarningLevel.critical,
          code: 'MONTHLY_270H_OVER',
          message: '月間拘束時間が労使協定上限の270時間を超えています。',
          targetDate: targetDate,
        ),
      );
    } else if (totalHours > 262.0) {
      warnings.add(
        ImprovementWarning(
          level: WarningLevel.warning,
          code: 'MONTHLY_262H_OVER',
          message: '月間拘束時間が原則上限の262時間を超えています。',
          targetDate: targetDate,
        ),
      );
    }

    return warnings;
  }
}
