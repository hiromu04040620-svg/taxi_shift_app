import '../models/shift_type.dart';

typedef ShiftCyclePreset = ({
  String id,
  String name,
  String description,
  List<ShiftType> cycle,
});

class ShiftCyclePresets {
  ShiftCyclePresets._();

  static const List<ShiftCyclePreset> all = [
    (
      id: 'standard_12',
      name: '標準（月12出番）',
      description: '2出番2休、最も一般的',
      cycle: [
        ShiftType.workDay,
        ShiftType.afterDuty,
        ShiftType.workDay,
        ShiftType.afterDuty,
        ShiftType.dayOff,
      ],
    ),
    (
      id: 'with_double_off',
      name: 'ダブ公サイクル',
      description: '週末にダブ公（連続2日公休）を含む',
      cycle: [
        ShiftType.workDay,
        ShiftType.afterDuty,
        ShiftType.workDay,
        ShiftType.afterDuty,
        ShiftType.workDay,
        ShiftType.afterDuty,
        ShiftType.dayOff,
      ],
    ),
    (
      id: 'light_11',
      name: '軽め（月11出番）',
      description: '連休重視、ゆとり優先',
      cycle: [ShiftType.workDay, ShiftType.afterDuty, ShiftType.dayOff],
    ),
    (
      id: 'heavy_13',
      name: 'がっつり（月13出番）',
      description: '出番多めで収入優先',
      cycle: [ShiftType.workDay, ShiftType.afterDuty],
    ),
  ];
}
