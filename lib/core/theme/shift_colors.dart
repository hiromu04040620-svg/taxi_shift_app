import 'package:flutter/material.dart';

extension ShiftColors on ColorScheme {
  // 出番 (workDay)
  Color get workDayBg => brightness == Brightness.light
      ? const Color(0xFFE3F2FD) // light blue 50
      : const Color(0xFF1A237E); // indigo 900
  Color get workDayFg => brightness == Brightness.light
      ? const Color(0xFF0D47A1) // blue 900
      : const Color(0xFF90CAF9); // blue 200

  // 明け (afterDuty)
  Color get afterDutyBg => brightness == Brightness.light
      ? const Color(0xFFF3E5F5) // purple 50
      : const Color(0xFF311B92); // deep purple 900
  Color get afterDutyFg => brightness == Brightness.light
      ? const Color(0xFF4A148C) // purple 900
      : const Color(0xFFCE93D8); // purple 200

  // 公休 (dayOff)
  Color get dayOffBg => brightness == Brightness.light
      ? const Color(0xFFFFEBEE) // red 50
      : const Color(0xFFB71C1C); // red 900
  Color get dayOffFg => brightness == Brightness.light
      ? const Color(0xFFB71C1C) // red 900
      : const Color(0xFFEF9A9A); // red 200

  // 公出 (extraWork)
  Color get extraWorkBg => brightness == Brightness.light
      ? const Color(0xFFFFF3E0) // orange 50
      : const Color(0xFFE65100); // orange 900
  Color get extraWorkFg => brightness == Brightness.light
      ? const Color(0xFFE65100) // orange 900
      : const Color(0xFFFFCC80); // orange 200

  // 指公 (optionalDayOff)
  Color get optionalDayOffBg => brightness == Brightness.light
      ? const Color(0xFFFFFDE7) // yellow 50
      : const Color(0xFFF57F17); // yellow 900
  Color get optionalDayOffFg => brightness == Brightness.light
      ? const Color(0xFFF57F17) // yellow 900
      : const Color(0xFFFFF59D); // yellow 200

  // 有休 (paidLeave)
  Color get paidLeaveBg => brightness == Brightness.light
      ? const Color(0xFFE8F5E9) // green 50
      : const Color(0xFF1B5E20); // green 900
  Color get paidLeaveFg => brightness == Brightness.light
      ? const Color(0xFF1B5E20) // green 900
      : const Color(0xFFA5D6A7); // green 200
}
