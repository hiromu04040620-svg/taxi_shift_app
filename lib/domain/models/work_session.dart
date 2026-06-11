import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_session.freezed.dart';

@freezed
abstract class WorkSession with _$WorkSession {
  const WorkSession._();

  const factory WorkSession({
    int? id,
    required DateTime shiftDate,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required int restMinutes,
    String? note,
  }) = _WorkSession;

  int get totalDurationMinutes =>
      endDateTime.difference(startDateTime).inMinutes;

  int get workingMinutes => totalDurationMinutes - restMinutes;

  bool get spansTwoDays =>
      startDateTime.day != endDateTime.day ||
      startDateTime.month != endDateTime.month ||
      startDateTime.year != endDateTime.year;
}
