import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/profile/models/visa_model.dart';

class AddCardViewModel extends ChangeNotifier {
  final nameCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final expiryCtrl = TextEditingController();
  final cvvCtrl = TextEditingController();

  Future<void> saveCard(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final cardNumber = numberCtrl.text.replaceAll(' ', '');
    if (cardNumber.length != 16) {
      _showStyledSnackBar(context, 'Card number must be 16 digits.');
      return;
    }

    final card = CardModel(
      cardholder: nameCtrl.text.trim(),
      number: numberCtrl.text.trim(),
      expiry: expiryCtrl.text.trim(),
      cvv: cvvCtrl.text.trim(),
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc('main')
        .set(card.toMap());

    Navigator.pop(context);
  }

  void disposeControllers() {
    nameCtrl.dispose();
    numberCtrl.dispose();
    expiryCtrl.dispose();
    cvvCtrl.dispose();
  }

  void _showStyledSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 8,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
