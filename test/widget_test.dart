import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_workforce/main.dart'; // Ensure this matches your pubspec name

void main() {
  testWidgets('App landing page test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Wait for the UI to stabilize
    await tester.pumpAndSettle();

    // Verify the text presence
    expect(find.text('Orbit'), findsOneWidget);
    expect(find.text('Workforce Management Platform'), findsOneWidget);
    expect(find.text('Ready to scale your team?'), findsOneWidget);
  });
}