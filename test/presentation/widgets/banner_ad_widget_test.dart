import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/presentation/widgets/banner_ad_widget.dart';

void main() {
  testWidgets('広告表示と広告非表示への導線を示す', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BannerAdWidget(
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('広告'), findsOneWidget);
    expect(find.text('広告非表示で画面を広く'), findsOneWidget);

    await tester.tap(find.byType(BannerAdWidget));
    expect(tapped, true);
  });
}
