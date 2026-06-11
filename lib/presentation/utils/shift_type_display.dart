import 'package:flutter/material.dart';

import '../../core/theme/shift_colors.dart';
import '../../domain/models/shift_type.dart';

class ShiftTypeDisplay {
  ShiftTypeDisplay._();

  static String shortLabel(ShiftType? type) {
    if (type == null) return '';
    switch (type) {
      case ShiftType.workDay:
        return '出';
      case ShiftType.afterDuty:
        return '明';
      case ShiftType.dayOff:
        return '公';
      case ShiftType.extraWork:
        return '公出';
      case ShiftType.optionalDayOff:
        return '指公';
      case ShiftType.paidLeave:
        return '有';
    }
  }

  static String fullLabel(ShiftType? type) {
    if (type == null) return '';
    switch (type) {
      case ShiftType.workDay:
        return '出番';
      case ShiftType.afterDuty:
        return '明け';
      case ShiftType.dayOff:
        return '公休';
      case ShiftType.extraWork:
        return '公出';
      case ShiftType.optionalDayOff:
        return '指定公休';
      case ShiftType.paidLeave:
        return '有給休暇';
    }
  }

  static Color backgroundColor(ShiftType? type, ColorScheme scheme) {
    if (type == null) return Colors.transparent;
    switch (type) {
      case ShiftType.workDay:
        return scheme.workDayBg;
      case ShiftType.afterDuty:
        return scheme.afterDutyBg;
      case ShiftType.dayOff:
        return scheme.dayOffBg;
      case ShiftType.extraWork:
        return scheme.extraWorkBg;
      case ShiftType.optionalDayOff:
        return scheme.optionalDayOffBg;
      case ShiftType.paidLeave:
        return scheme.paidLeaveBg;
    }
  }

  static Color foregroundColor(ShiftType? type, ColorScheme scheme) {
    if (type == null) return Colors.transparent;
    switch (type) {
      case ShiftType.workDay:
        return scheme.workDayFg;
      case ShiftType.afterDuty:
        return scheme.afterDutyFg;
      case ShiftType.dayOff:
        return scheme.dayOffFg;
      case ShiftType.extraWork:
        return scheme.extraWorkFg;
      case ShiftType.optionalDayOff:
        return scheme.optionalDayOffFg;
      case ShiftType.paidLeave:
        return scheme.paidLeaveFg;
    }
  }
}
