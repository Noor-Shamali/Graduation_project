import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'signin_screen.dart'; // Import Sign-In screen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  late Database database;
  String emailError = '';
  String firstNameError = '';
  String lastNameError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = p.join(databasePath, 'users.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, email TEXT UNIQUE, firstName TEXT, lastName TEXT, password TEXT)',
        );
      },
    );
  }

  Future<void> registerUser() async {
    final email = emailController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    setState(() {
      emailError = '';
      firstNameError = '';
      lastNameError = '';
      passwordError = '';
      confirmPasswordError = '';
    });

    bool isValid = true;

    if (email.isEmpty ||
        !RegExp(r'^[a-zA-Z0-9.+_-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+$')
            .hasMatch(email)) {
      setState(() {
        emailError = 'Invalid email format';
      });
      isValid = false;
    }

    if (firstName.isEmpty || firstName.length < 5 || firstName.length > 20) {
      setState(() {
        firstNameError = 'First name must be between 5-20 characters';
      });
      isValid = false;
    }

    if (lastName.isEmpty || lastName.length < 5 || lastName.length > 20) {
      setState(() {
        lastNameError = 'Last name must be between 5-20 characters';
      });
      isValid = false;
    }

    if (password.isEmpty || !isValidPassword(password)) {
      setState(() {
        passwordError =
            'Password must be 6-12 characters with uppercase, lowercase, and numbers';
      });
      isValid = false;
    }

    if (confirmPassword.isEmpty || password != confirmPassword) {
      setState(() {
        confirmPasswordError = 'Passwords do not match';
      });
      isValid = false;
    }

    if (isValid) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.20:3000/api/register'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'firstName': firstName,
            'lastName': lastName,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseBody['message'])),
            );
            // Navigate to Sign-In screen after successful registration
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          }
        } else {
          final responseBody = json.decode(response.body);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseBody['message'])),
            );
          }
        }
      } catch (e) {
        debugPrint("Error during API request: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('An error occurred. Please try again.')),
          );
        }
      }
    }
  }

  bool isValidPassword(String password) {
    return password.length >= 6 &&
        password.length <= 12 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'\d').hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), // Light purple background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 50), // Add space at the top
            Column(
              children: [
                Image.asset(
                  'assets/logo.png', // Path to your logo
                  height: 150,
                  width: 150,
                  fit:
                      BoxFit.contain, // Ensures the image scales proportionally
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
              controller: firstNameController,
              labelText: 'First Name',
              errorText: firstNameError,
            ),
            _buildTextField(
              controller: lastNameController,
              labelText: 'Last Name',
              errorText: lastNameError,
            ),
            _buildTextField(
              controller: passwordController,
              labelText: 'Password',
              errorText: passwordError,
              obscureText: true,
            ),
            _buildTextField(
              controller: confirmPasswordController,
              labelText: 'Confirm Password',
              errorText: confirmPasswordError,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 79, 46, 158), // Button background
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text(
                'Register',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color is defined here
                ),
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
