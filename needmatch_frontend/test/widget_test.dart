import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';
import '../lib/screens/login_screen.dart';
import '../lib/screens/register_screen.dart';

void main() {
  testWidgets('NeedMatch app loads the real WelcomeScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NeedMatchApp());

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('NeedMatch'), findsOneWidget);
    expect(find.text('We Match. You Make an Impact.'), findsOneWidget);
    expect(find.text('Share what you have.'), findsOneWidget);
    expect(find.text('Find what you need.'), findsOneWidget);
    expect(find.text('Build a better community.'), findsOneWidget);

    expect(find.text('Create an Account'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);
  });

  testWidgets('Create an Account opens the real RegisterScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NeedMatchApp());

    final createAccountButton = find.text('Create an Account');

    // The button is below the visible 800x600 test viewport.
    // Scroll the real WelcomeScreen until it is visible.
    await tester.ensureVisible(createAccountButton);
    await tester.pumpAndSettle();

    await tester.tap(createAccountButton);
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
  });

  testWidgets('Login opens the real LoginScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NeedMatchApp());

    final loginButton = find.text('Login');

    // The Login button is also below the initial test viewport.
    await tester.ensureVisible(loginButton);
    await tester.pumpAndSettle();

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
