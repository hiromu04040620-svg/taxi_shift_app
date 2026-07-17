import 'package:flutter/material.dart';

extension ShiftColors on ColorScheme {
  // 出番 (workDay)
  Color get workDayBg => brightness == Brightness.light
      ? const Color(0xFFE3F1ED)
      : const Color(0xFF213A35);
  Color get workDayFg => brightness == Brightness.light
      ? const Color(0xFF245C52)
      : const Color(0xFFC2DDD6);

  // 明け (afterDuty)
  Color get afterDutyBg => brightness == Brightness.light
      ? const Color(0xFFEDF1EF)
      : const Color(0xFF2A3330);
  Color get afterDutyFg => brightness == Brightness.light
      ? const Color(0xFF4B5E58)
      : const Color(0xFFCBD5D1);

  // 公休 (dayOff)
  Color get dayOffBg => brightness == Brightness.light
      ? const Color(0xFFF5ECEE)
      : const Color(0xFF433237);
  Color get dayOffFg => brightness == Brightness.light
      ? const Color(0xFF76545B)
      : const Color(0xFFE7CCD1);

  // 公出 (extraWork)
  Color get extraWorkBg => brightness == Brightness.light
      ? const Color(0xFFF5F0E2)
      : const Color(0xFF403A2B);
  Color get extraWorkFg => brightness == Brightness.light
      ? const Color(0xFF6F6037)
      : const Color(0xFFE4D6AA);

  // 指公 (optionalDayOff)
  Color get optionalDayOffBg => brightness == Brightness.light
      ? const Color(0xFFEDF2E8)
      : const Color(0xFF333B30);
  Color get optionalDayOffFg => brightness == Brightness.light
      ? const Color(0xFF52634A)
      : const Color(0xFFD0D9CB);

  // 有休 (paidLeave)
  Color get paidLeaveBg => brightness == Brightness.light
      ? const Color(0xFFE6F1E9)
      : const Color(0xFF294033);
  Color get paidLeaveFg => brightness == Brightness.light
      ? const Color(0xFF3F654B)
      : const Color(0xFFC4DDCA);
}
