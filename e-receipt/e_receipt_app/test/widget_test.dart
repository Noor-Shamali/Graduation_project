import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import sqflite_common_ffi
import 'package:e_receipt_app/signup_screen.dart';

void main() {
  // Initialize the ffi-based database factory for testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('Validation errors are displayed when fields are empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

    // Tap the "Register" button without filling in the fields
    await tester.tap(find.text('Register'));
    await tester.pump();

    // Verify validation error messages
    expect(find.text('Invalid email format'), findsOneWidget);
    expect(find.text('First name must be between 5-20 characters'),
        findsOneWidget);
    expect(
        find.text('Last name must be between 5-20 characters'), findsOneWidget);
    expect(
        find.text(
            'Password must be 6-12 characters with uppercase, lowercase, and numbers'),
        findsOneWidget);
    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
