import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/app.dart';

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

    // Note: Theme testing is moved to settings tests.
  });
}
