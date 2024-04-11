import 'package:finance_tracker/authscreen/login.dart';
import 'package:finance_tracker/authscreen/signup.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  final bool? showLoginPage;
  const LoginOrRegister({super.key, this.showLoginPage});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
  void toggleView() {
    setState(() => showLoginPage = !showLoginPage);
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(toggleView: toggleView);
    } else {
      return SignupPage(toggleView: toggleView);
    }
  }
}
