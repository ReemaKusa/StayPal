import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/screens/auth/views/auth_entry_view.dart';

class LogoutViewModel {
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthEntryView()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    }
  }
}