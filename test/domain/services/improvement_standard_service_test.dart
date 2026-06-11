import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/domain/models/improvement_warning.dart';
import 'package:taxi_shift_app/domain/models/work_session.dart';
import 'package:taxi_shift_app/domain/services/improvement_standard_service.dart';

void main() {
  late ImprovementStandardService service;

  setUp(() {
    service = ImprovementStandardService();
  });

  WorkSession createSession(
    int durationHours, {
    DateTime? shiftDate,
    DateTime? start,
  }) {
    final startDt = start ?? DateTime(2023, 1, 1, 8);
    return WorkSession(
      id: 1,
      shiftDate: shiftDate ?? DateTime(2023),
      startDateTime: startDt,
      endDateTime: startDt.add(Duration(hours: durationHours)),
      restMinutes: 180, // 3 hours rest
    );
  }

  group('checkSingleSession', () {
    test('拘束時間20h: 警告なし', () {
      final session = createSession(20);
      final warnings = service.checkSingleSession(session);
      expect(warnings, isEmpty);
    });

    test('拘束時間21.5h: warning レベル発生', () {
      final manualSession = WorkSession(
        id: 1,
        shiftDate: DateTime(2023),
        startDateTime: DateTime(2023, 1, 1, 8),
        endDateTime: DateTime(
          2023,
          1,
          1,
          8,
        ).add(const Duration(hours: 21, minutes: 30)),
        restMinutes: 180,
      );
      final warnings = service.checkSingleSession(manualSession);
      expect(warnings, hasLength(1));
      expect(warnings.first.level, WarningLevel.warning);
      expect(warnings.first.code, 'KAIKETSU_21H_OVER');
    });

    test('拘束時間24.5h: critical レベル発生', () {
      final session = WorkSession(
        id: 1,
        shiftDate: DateTime(2023),
        startDateTime: DateTime(2023, 1, 1, 8),
        endDateTime: DateTime(
          2023,
          1,
          1,
          8,
        ).add(const Duration(hours: 24, minutes: 30)),
        restMinutes: 180,
      );
      final warnings = service.checkSingleSession(session);
      expect(warnings, hasLength(1));
      expect(warnings.first.level, WarningLevel.critical);
      expect(warnings.first.code, 'KAIKETSU_24H_OVER');
    });
  });

  group('checkConsecutiveRest', () {
    test('連続休息19h: warning 発生', () {
      final previous = createSession(20, start: DateTime(2023, 1, 1, 8));
      // previous ends at 2023-01-02 04:00
      final current = createSession(20, start: DateTime(2023, 1, 2, 23));
      // 19 hours rest
      final warnings = service.checkConsecutiveRest(current, previous);
      expect(warnings, hasLength(1));
      expect(warnings.first.level, WarningLevel.warning);
      expect(warnings.first.code, 'CONSECUTIVE_REST_UNDER_20H');
    });

    test('連続休息21h: 警告なし', () {
      final previous = createSession(20, start: DateTime(2023, 1, 1, 8));
      // previous ends at 2023-01-02 04:00
      final current = createSession(20, start: DateTime(2023, 1, 3, 1));
      // 21 hours rest
      final warnings = service.checkConsecutiveRest(current, previous);
      expect(warnings, isEmpty);
    });
  });

  group('checkMonthlyTotal', () {
    test('月12出番×20h=240h: 警告なし', () {
      final sessions = List.generate(
        12,
        (i) => createSession(20, shiftDate: DateTime(2023, 1, i + 1)),
      );
      final warnings = service.checkMonthlyTotal(sessions);
      expect(warnings, isEmpty);
    });

    test('月13出番×21h=273h: critical 発生', () {
      final sessions = List.generate(
        13,
        (i) => createSession(21, shiftDate: DateTime(2023, 1, i + 1)),
      );
      final warnings = service.checkMonthlyTotal(sessions);
      expect(warnings, hasLength(1));
      expect(warnings.first.level, WarningLevel.critical);
      expect(warnings.first.code, 'MONTHLY_270H_OVER');
    });
  });
}
