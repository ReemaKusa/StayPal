import 'package:flutter/material.dart';
import 'package:staypal/screens/auth/views/login_view.dart';
import 'package:staypal/screens/auth/views/signup_view.dart';

class AuthEntryViewModel {
  void goToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpView()),
    );
  }

  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
    );
  }
}