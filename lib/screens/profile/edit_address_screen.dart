import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';

class EditAddressScreen extends StatefulWidget {
  EditAddressScreen({super.key});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _addressCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();

  final _addressFocus = FocusNode();
  final _zipFocus = FocusNode();
  final _cityFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    loadCurrentAddress();
    _addressFocus.addListener(() => setState(() {}));
    _zipFocus.addListener(() => setState(() {}));
    _cityFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _addressFocus.dispose();
    _zipFocus.dispose();
    _cityFocus.dispose();
    super.dispose();
  }

  Future<void> loadCurrentAddress() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _addressCtrl.text = data['address'] ?? '';
        _zipCtrl.text = data['zipCode'] ?? '';
        _cityCtrl.text = data['city'] ?? '';
      });
    }
  }

  Future<void> saveAddress() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'country': 'Palestine',
      'address': _addressCtrl.text.trim(),
      'zipCode': _zipCtrl.text.trim(),
      'city': _cityCtrl.text.trim(),
    });

    Navigator.pop(context);
  }

  OutlineInputBorder _inputBorder(FocusNode focusNode) => OutlineInputBorder(
    borderSide: BorderSide(
      color: focusNode.hasFocus ? AppColors.primary : AppColors.greyTransparent,
    ),
    borderRadius: BorderRadius.circular(AppBorderRadius.card),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'Address',
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
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Country/Region',
                labelStyle: TextStyle(color: AppColors.grey),

                border: OutlineInputBorder(
                  
                  borderSide: BorderSide(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(AppBorderRadius.card),
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
              style: TextStyle(color: AppColors.black),
              controller: TextEditingController(text: 'Palestine'),
            ),
            SizedBox(height: AppSpacing.large),
            TextField(
              controller: _addressCtrl,
              focusNode: _addressFocus,
              decoration: InputDecoration(
                labelText: 'Address',
                                labelStyle: TextStyle(color: AppColors.grey),

                filled: true,
                fillColor: AppColors.white,
                border: _inputBorder(_addressFocus),
                focusedBorder: _inputBorder(_addressFocus),
                enabledBorder: _inputBorder(_addressFocus),
              ),
            ),
            SizedBox(height: AppSpacing.large),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _zipCtrl,
                    focusNode: _zipFocus,
                    decoration: InputDecoration(
                      labelText: 'Zip Code',
                                      labelStyle: TextStyle(color: AppColors.grey),

                      filled: true,
                      fillColor: AppColors.white,
                      border: _inputBorder(_zipFocus),
                      focusedBorder: _inputBorder(_zipFocus),
                      enabledBorder: _inputBorder(_zipFocus),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.large),
                Expanded(
                  child: TextField(
                    controller: _cityCtrl,
                    focusNode: _cityFocus,
                    decoration: InputDecoration(
                      labelText: 'Town/City',
                      labelStyle: TextStyle(color: AppColors.grey),

                      filled: true,
                      fillColor: AppColors.white,
                      border: _inputBorder(_cityFocus),
                      focusedBorder: _inputBorder(_cityFocus),
                      enabledBorder: _inputBorder(_cityFocus),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                minimumSize: Size.fromHeight(AppPadding.buttonVertical * 3),
                side: BorderSide(color: AppColors.greyTransparent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.card),
                ),
              ),
              onPressed: saveAddress,
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.buttonVertical),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: AppFontSizes.bottonfont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
