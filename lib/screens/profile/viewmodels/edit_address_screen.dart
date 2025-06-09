import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditAddressViewModel extends ChangeNotifier {
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController zipCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();

  final FocusNode addressFocus = FocusNode();
  final FocusNode zipFocus = FocusNode();
  final FocusNode cityFocus = FocusNode();

  EditAddressViewModel() {
    loadCurrentAddress();
    _addFocusListeners();
  }

  void _addFocusListeners() {
    addressFocus.addListener(notifyListeners);
    zipFocus.addListener(notifyListeners);
    cityFocus.addListener(notifyListeners);
  }

  Future<void> loadCurrentAddress() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      final data = doc.data()!;
      addressCtrl.text = data['address'] ?? '';
      zipCtrl.text = data['zipCode'] ?? '';
      cityCtrl.text = data['city'] ?? '';
      notifyListeners();
    }
  }

  Future<void> saveAddress(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'country': 'Palestine',
      'address': addressCtrl.text.trim(),
      'zipCode': zipCtrl.text.trim(),
      'city': cityCtrl.text.trim(),
    });

    Navigator.pop(context);
  }

  void disposeControllers() {
    addressCtrl.dispose();
    zipCtrl.dispose();
    cityCtrl.dispose();
    addressFocus.dispose();
    zipFocus.dispose();
    cityFocus.dispose();
  }
}
