import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/screens/auth/auth_entry_screen.dart';

Future<void> signOutUser(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthEntryScreen()),
          (Route<dynamic> route) => false,
    );
  } catch (e) {
    print('❌ Error signing out: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to log out. Try again.')),
    );
  }
}