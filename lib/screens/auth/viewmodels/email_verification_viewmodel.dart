import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/screens/auth/views/login_view.dart';

class EmailVerificationViewModel {
  final auth = FirebaseAuth.instance;

  Future<void> resendVerificationEmail(BuildContext context) async {
    try {
      await auth.currentUser?.sendEmailVerification();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📨 Verification email sent again.')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> checkVerification(BuildContext context) async {
    await auth.currentUser?.reload();
    final user = auth.currentUser;
    if (!context.mounted) return;

    if (user != null && user.emailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your email is not verified yet.')),
      );
    }
  }

  Future<void> signOutToLogin(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
    );
  }
}