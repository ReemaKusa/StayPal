import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditNameViewModel extends ChangeNotifier {
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();

  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();

  EditNameViewModel() {
    loadCurrentName();
    firstNameFocus.addListener(notifyListeners);
    lastNameFocus.addListener(notifyListeners);
  }

  Future<void> loadCurrentName() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      final fullName = doc.data()?['fullName'] ?? '';
      final parts = fullName.split(' ');
      firstNameCtrl.text = parts.isNotEmpty ? parts.first : '';
      lastNameCtrl.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      notifyListeners();
    }
  }

  Future<void> saveName(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final fullName = '${firstNameCtrl.text.trim()} ${lastNameCtrl.text.trim()}';
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'fullName': fullName,
    });

    Navigator.pop(context);
  }

  void disposeResources() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
  }
}
