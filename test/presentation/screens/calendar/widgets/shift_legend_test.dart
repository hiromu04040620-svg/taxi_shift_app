import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/domain/models/shift_type.dart';
import 'package:taxi_shift_app/presentation/screens/calendar/widgets/shift_legend.dart';
import 'package:taxi_shift_app/presentation/utils/shift_type_display.dart';

void main() {
  testWidgets('狭い画面でもすべての勤務区分を画面内に表示する', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 220);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Align(alignment: Alignment.topCenter, child: ShiftLegend()),
        ),
      ),
    );

    final labelRects = <Rect>[];
    for (final type in ShiftType.values) {
      final label = find.text(ShiftTypeDisplay.fullLabel(type));
      expect(label, findsAtLeastNWidgets(1));
      final rect = tester.getRect(label.last);
      labelRects.add(rect);
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(390));
    }
    expect(labelRects.map((rect) => rect.top).toSet(), hasLength(1));
  });
}
