import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/screens/auth/views/email_verification_view.dart';

class SignUpViewModel {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  void disposeControllers() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
  }

  Future<void> signUpUser(BuildContext context) async {
    final fullName = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    final confirmPassword = confirmPasswordCtrl.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage(context, 'Please fill all the fields');
      return;
    }

    if (password != confirmPassword) {
      _showMessage(context, 'Passwords do not match');
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(fullName);

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': fullName,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
          'dob': '',
          'gender': '',
          'phone': '',
          'address': '',
          'city': '',
          'country': '',
          'zipCode': '',
          'imageUrl': '',
          'role': 'user', // 👈 Auto assign role
        });

        await user.sendEmailVerification();

        if (!context.mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmailVerificationView()),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      _showMessage(context, e.toString());
    }
  }

  void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  InputDecoration inputDecoration(String hint) => InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.black54),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.black12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color.fromRGBO(255, 87, 34, 1), width: 2),
    ),
  );

  InputDecoration passwordInputDecoration(String hint, bool isHidden, VoidCallback onToggle) {
    return inputDecoration(hint).copyWith(
      suffixIcon: IconButton(
        icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility, color: Colors.black12),
        onPressed: onToggle,
      ),
    );
  }
}