import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';

class EditPhoneScreen extends StatefulWidget {
  const EditPhoneScreen({super.key});

  @override
  State<EditPhoneScreen> createState() => _EditPhoneScreenState();
}

class _EditPhoneScreenState extends State<EditPhoneScreen> {
  final _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    loadCurrentPhone();
    _phoneFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneFocus.dispose();
    super.dispose();
  }

  Future<void> loadCurrentPhone() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      setState(() {
        _phoneController.text = doc.data()?['phone'] ?? '';
      });
    }
  }

  Future<void> savePhone() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'phone': _phoneController.text.trim(),
    });

    Navigator.pop(context);
  }

  OutlineInputBorder _inputBorder(FocusNode focusNode) => OutlineInputBorder(
    borderSide: BorderSide(
      color: focusNode.hasFocus ? AppColors.primary : AppColors.grey,
    ),
    borderRadius: BorderRadius.circular(AppBorderRadius.card),
  );

  InputDecoration _buildInputDecoration(String label, FocusNode focusNode) =>
      InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: AppColors.white,
        border: _inputBorder(focusNode),
        focusedBorder: _inputBorder(focusNode),
        enabledBorder: _inputBorder(focusNode),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'Phone Number',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSizes.title,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppPadding.formHorizontal),
        child: Column(
          children: [
            TextField(
              
              controller: _phoneController,
              focusNode: _phoneFocus,
              keyboardType: TextInputType.phone,
              decoration: _buildInputDecoration('Phone Number', _phoneFocus,),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: savePhone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                minimumSize: Size.fromHeight(AppPadding.buttonVertical * 3),
                side: BorderSide(color: AppColors.greyTransparent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.card),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.bottonfont,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
