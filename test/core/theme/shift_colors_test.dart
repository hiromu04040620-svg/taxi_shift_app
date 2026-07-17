import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/core/theme/color_schemes.dart';
import 'package:taxi_shift_app/core/theme/shift_colors.dart';

void main() {
  group('ShiftColors', () {
    test('ライトモードで承認済みの淡色パレットを返す', () {
      final scheme = AppColorSchemes.light;

      expect(scheme.workDayBg, const Color(0xFFE3F1ED));
      expect(scheme.workDayFg, const Color(0xFF245C52));
      expect(scheme.afterDutyBg, const Color(0xFFEDF1EF));
      expect(scheme.afterDutyFg, const Color(0xFF4B5E58));
      expect(scheme.dayOffBg, const Color(0xFFF5ECEE));
      expect(scheme.dayOffFg, const Color(0xFF76545B));
      expect(scheme.extraWorkBg, const Color(0xFFF5F0E2));
      expect(scheme.extraWorkFg, const Color(0xFF6F6037));
      expect(scheme.optionalDayOffBg, const Color(0xFFEDF2E8));
      expect(scheme.optionalDayOffFg, const Color(0xFF52634A));
      expect(scheme.paidLeaveBg, const Color(0xFFE6F1E9));
      expect(scheme.paidLeaveFg, const Color(0xFF3F654B));
    });

    test('ダークモードで承認済みの低彩度パレットを返す', () {
      final scheme = AppColorSchemes.dark;

      expect(scheme.workDayBg, const Color(0xFF213A35));
      expect(scheme.workDayFg, const Color(0xFFC2DDD6));
      expect(scheme.afterDutyBg, const Color(0xFF2A3330));
      expect(scheme.afterDutyFg, const Color(0xFFCBD5D1));
      expect(scheme.dayOffBg, const Color(0xFF433237));
      expect(scheme.dayOffFg, const Color(0xFFE7CCD1));
      expect(scheme.extraWorkBg, const Color(0xFF403A2B));
      expect(scheme.extraWorkFg, const Color(0xFFE4D6AA));
      expect(scheme.optionalDayOffBg, const Color(0xFF333B30));
      expect(scheme.optionalDayOffFg, const Color(0xFFD0D9CB));
      expect(scheme.paidLeaveBg, const Color(0xFF294033));
      expect(scheme.paidLeaveFg, const Color(0xFFC4DDCA));
    });

    test('全勤務区分の文字コントラストがWCAG AAを満たす', () {
      for (final scheme in [AppColorSchemes.light, AppColorSchemes.dark]) {
        for (final pair in _pairs(scheme)) {
          expect(
            _contrastRatio(pair.background, pair.foreground),
            greaterThanOrEqualTo(4.5),
          );
        }
      }
    });
  });
}

List<_ShiftColorPair> _pairs(ColorScheme scheme) => [
  _ShiftColorPair(scheme.workDayBg, scheme.workDayFg),
  _ShiftColorPair(scheme.afterDutyBg, scheme.afterDutyFg),
  _ShiftColorPair(scheme.dayOffBg, scheme.dayOffFg),
  _ShiftColorPair(scheme.extraWorkBg, scheme.extraWorkFg),
  _ShiftColorPair(scheme.optionalDayOffBg, scheme.optionalDayOffFg),
  _ShiftColorPair(scheme.paidLeaveBg, scheme.paidLeaveFg),
];

double _contrastRatio(Color first, Color second) {
  final lighter = [
    first.computeLuminance(),
    second.computeLuminance(),
  ].reduce((left, right) => left > right ? left : right);
  final darker = [
    first.computeLuminance(),
    second.computeLuminance(),
  ].reduce((left, right) => left < right ? left : right);
  return (lighter + 0.05) / (darker + 0.05);
}

class _ShiftColorPair {
  const _ShiftColorPair(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
