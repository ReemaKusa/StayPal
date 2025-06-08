import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({super.key});

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    loadCurrentName();
    _firstNameFocus.addListener(() => setState(() {}));
    _lastNameFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    super.dispose();
  }

  Future<void> loadCurrentName() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      final fullName = doc.data()?['fullName'] ?? '';
      final parts = fullName.split(' ');
      setState(() {
        _firstNameCtrl.text = parts.isNotEmpty ? parts.first : '';
        _lastNameCtrl.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      });
    }
  }

  Future<void> saveName() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final fullName =
        '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}';
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'fullName': fullName,
    });

    Navigator.pop(context);
  }

  OutlineInputBorder _inputBorder(FocusNode focusNode) => OutlineInputBorder(
    borderSide: BorderSide(
      color: focusNode.hasFocus ? AppColors.primary : AppColors.greyTransparent,
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
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'Edit Name',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSizes.title,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppPadding.formHorizontal,
          right: AppPadding.formHorizontal,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _firstNameCtrl,
              focusNode: _firstNameFocus,
              decoration: _buildInputDecoration(
                'First Name *',
                _firstNameFocus,
              ),
            ),
            SizedBox(height: AppSpacing.medium),
            TextField(
              controller: _lastNameCtrl,
              focusNode: _lastNameFocus,
              decoration: _buildInputDecoration('Last Name *', _lastNameFocus),
            ),
            SizedBox(height: 40), // بدل Spacer
            ElevatedButton(
              onPressed: saveName,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                elevation: 3,
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
