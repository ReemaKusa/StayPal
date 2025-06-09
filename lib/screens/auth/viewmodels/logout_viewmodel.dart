import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:staypal/screens/profile/viewmodels/profile_viewmodel.dart';
import 'package:staypal/screens/homePage/views/home_page.dart';

class LogoutViewModel {
  Future<void> logout(BuildContext context) async {
    try {
      // ✅ Reset ProfileViewModel state
      Provider.of<ProfileViewModel>(context, listen: false).reset();

      // ✅ Sign out the user
      await FirebaseAuth.instance.signOut();

      // ✅ Navigate to login screen and clear navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }
}