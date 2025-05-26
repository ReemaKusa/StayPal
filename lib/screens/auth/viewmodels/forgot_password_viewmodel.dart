import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordViewModel {
  final TextEditingController emailCtrl = TextEditingController();

  void disposeController() {
    emailCtrl.dispose();
  }

  Future<void> sendResetLink(BuildContext context) async {
    final email = emailCtrl.text.trim();

    if (email.isEmpty) {
      _showMessage(context, 'Please enter your email address');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showMessage(context, 'Password reset email sent');
    } catch (e) {
      _showMessage(context, 'Failed to send reset email');
    }
  }

  void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  InputDecoration inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
        ),
      );
}