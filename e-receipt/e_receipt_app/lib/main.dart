import 'package:flutter/material.dart';
import 'mainPage.dart';
import 'signup_screen.dart'; // Import your SignUpPage file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Track Receipts',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => const MainPage(), // MainPage as the home screen
        '/signup': (context) => const SignUpScreen(), // Add the signup route
      },
    );
  }
}
