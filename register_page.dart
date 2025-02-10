import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'home_page.dart';
import 'my_button.dart';
import 'text_field.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required VoidCallback onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  Future<void> registerUser(BuildContext context, String email, String password) async {
    final authService = AuthService();
    try {
      UserCredential userCredential = await authService.registerWithEmailAndPassword(email, password);

      if (userCredential != null) {
        // Navigate to HomePage after registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const  HomePage(),
          ),
        );
      }
    } catch (e) {
      print("Registration failed: $e");
      // Show error message to the user if registration fails
    }
  }


  /// Method to navigate to the login page
  void _navigateLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(onTap: () {},)),
    );
  }

  /// Method to handle registration
  void _handleRegister(BuildContext context) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black,
          title: const Text('Error'),
          content: const Text('Please enter both email and password',
            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,
          ),),

          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
            }, child: const Text("Ok")),
          ],
        ),

      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.red,
          title: const Text('Error'),
          content: const Text('Passwords do not match'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }


    final authService = AuthService();
    try {
      await authService.registerWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      Navigator.pop(context); // Navigate back to the previous page.
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade400,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        foregroundColor: Colors.white,
        title: const Center(child: Text('Register Page')),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.chat, size: 60, color: Colors.blue),
                  const Text(
                    "Let's create an Account",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  MyButton(
                    text: 'Register',
                    onTap: () => _handleRegister(context),
                  ),
                  const SizedBox(height: 45),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: _navigateLoginPage,
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
