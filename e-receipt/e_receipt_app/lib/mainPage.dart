import 'package:flutter/material.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), // Light purple background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50), // Add space at the top
              Column(
                children: [
                  Image.asset(
                    'assets/logo.png', // Path to your logo
                    height: 150,
                    width: 150,
                    fit: BoxFit
                        .contain, // Ensures the image scales proportionally
                  ),
                  const Text(
                    'Track Receipts',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 79, 46, 158), // Purple color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40), // Space between the logo and buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 79, 46, 158),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 150.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color is white
                  ),
                ),
              ),
              const SizedBox(height: 20), // Space between the buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 79, 46, 158),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 150.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color is white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
