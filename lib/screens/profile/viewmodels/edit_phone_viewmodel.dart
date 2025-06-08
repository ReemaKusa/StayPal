import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPhoneViewModel extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final FocusNode phoneFocus = FocusNode();

  EditPhoneViewModel() {
    loadCurrentPhone();
    phoneFocus.addListener(notifyListeners);
  }

  Future<void> loadCurrentPhone() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      phoneController.text = doc.data()?['phone'] ?? '';
      notifyListeners();
    }
  }

  Future<void> savePhone(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'phone': phoneController.text.trim(),
    });

    Navigator.pop(context);
  }

  void disposeResources() {
    phoneController.dispose();
    phoneFocus.dispose();
  }
}
