import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_workforce/main.dart';

void main() {
  testWidgets('App starts and shows landing page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our landing page text is present.
    expect(find.text('Orbit'), findsOneWidget);
    expect(find.text('Workforce Management Platform'), findsOneWidget);
    expect(find.text('Ready to scale your team?'), findsOneWidget);
  });
}
