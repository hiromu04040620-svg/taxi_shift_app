import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/app.dart';
import 'package:taxi_shift_app/application/providers/theme_provider.dart';

void main() {
  testWidgets('TaxiShiftApp smoke test', (WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TaxiShiftApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hello, TaxiShift'), findsOneWidget);

    // Initial theme mode
    expect(container.read(themeModeControllerProvider), ThemeMode.system);

    // Switch to dark
    container
        .read(themeModeControllerProvider.notifier)
        .setMode(ThemeMode.dark);
    await tester.pumpAndSettle();
    expect(container.read(themeModeControllerProvider), ThemeMode.dark);
  });
}
