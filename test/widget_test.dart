import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/login/screen/login_screen.dart';

void main() {
  testWidgets('Email validation test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LoginScreen(),
    ));

    // Find the TextFormField for email by type
    final emailField = find.byType(TextFormField).first;
    expect(emailField, findsOneWidget);

    // Simulate entering an invalid email address
    await tester.enterText(emailField, 'invalidemail');

    // Find the login button and tap it
    final loginButton = find.text('Login');
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pump();

  });
}
