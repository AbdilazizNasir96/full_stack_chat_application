import 'package:chat_application/login_page.dart';
import 'package:chat_application/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;

  // Toggling between pages
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;  // Call setState to trigger UI update
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePage,  // Passing the callback to LoginPage
      );
    } else {
      return RegisterPage(
        onTap: togglePage,  // Passing the callback to RegisterPage
      );
    }
  }
}
