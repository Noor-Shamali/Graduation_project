import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String emailError = '';
  String passwordError = '';
  bool loginSuccess = false;

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      emailError = '';
      passwordError = '';
    });

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        if (email.isEmpty) emailError = 'Email is required';
        if (password.isEmpty) passwordError = 'Password is required';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.20:3000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            loginSuccess = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful')),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            if (responseBody['message'] == 'Email not found.') {
              emailError = 'Invalid email address';
            } else if (responseBody['message'] == 'Incorrect password.') {
              passwordError = 'Incorrect password';
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Error during API request: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), // Light purple background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50), // Add space at the top
            Column(
              children: [
                Image.asset(
                  'assets/logo.png', // Path to your logo
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
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
            const SizedBox(height: 30),
            _buildTextField(
              controller: emailController,
              labelText: 'Email',
              errorText: emailError,
            ),
            _buildTextField(
              controller: passwordController,
              labelText: 'Password',
              errorText: passwordError,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 79, 46, 158),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/signup'); // Navigate to Sign-Up screen
              },
              child: const Text(
                "Don't have an account? Sign up",
                style: TextStyle(color: Color.fromARGB(255, 79, 46, 158)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? errorText,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          errorText: errorText?.isEmpty == true ? null : errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
