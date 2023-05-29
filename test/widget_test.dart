// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:daily_gym_planner/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Go to LogIn Page', (WidgetTester tester) async {

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);

    // Execute the actual test
    await tester.tap(find.byKey(const ValueKey("loginButton")));
    await tester.pumpAndSettle();

    // Check outputs
    expect(find.text("Log In into your account"), findsOneWidget);
    expect(find.text("Log In"), findsOneWidget);
    expect(find.text("Sign Up"), findsNothing);
  });

  testWidgets('Go to SignUp Page', (WidgetTester tester) async {

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);

    // Execute the actual test
    await tester.tap(find.byKey(const ValueKey("signupButton")));
    await tester.pumpAndSettle();

    // Check outputs
    expect(find.text("Sign Up"), findsOneWidget);
    expect(find.text("Log In"), findsNothing);
  });
}
