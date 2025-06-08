import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/constants/app_constants.dart';

class PersonalDetailsViewModel {
  Map<String, dynamic> userData = {};
  bool loading = true;
  String? selectedGender;

  Future<void> fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      userData = doc.data()!;
      selectedGender = userData['gender'];
    }
    loading = false;
  }

  Future<void> updateField(String field, dynamic value) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      field: value,
    });
    await fetchUserData();
  }

  void selectGender(BuildContext context, VoidCallback onUpdate) {
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: AppSizes.sizedbox,
              child: Column(
                children: [
                  RadioListTile<String>(
                    activeColor: AppColors.primary,
                    title: Text(
                      "Male",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.subtitle,
                      ),
                    ),
                    value: 'Male',
                    groupValue: selectedGender,
                    onChanged:
                        (value) => setModalState(() => selectedGender = value),
                  ),
                  RadioListTile<String>(
                    activeColor: AppColors.primary,
                    title: Text(
                      "Female",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.subtitle,
                      ),
                    ),
                    value: 'Female',
                    groupValue: selectedGender,
                    onChanged:
                        (value) => setModalState(() => selectedGender = value),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppPadding.formHorizontal),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        backgroundColor: AppColors.white,
                         shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppBorderRadius.card),
    ),
    side: BorderSide(color: AppColors.greyTransparent),
                      ),
                      onPressed: () async {
                        if (selectedGender != null) {
                          await updateField('gender', selectedGender);
                          onUpdate();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: AppFontSizes.subtitle,

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void pickDateOfBirth(BuildContext context, VoidCallback onUpdate) {
    DateTime selectedDate = DateTime(2000);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.card),
        ),
      ),
      builder: (_) {
        return SizedBox(
          height: AppSizes.sizedbox,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime(2000),
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged:
                      (DateTime newDate) => selectedDate = newDate,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppPadding.formHorizontal),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      
                      side: BorderSide(color: AppColors.greyTransparent),
                      borderRadius: BorderRadius.circular(AppBorderRadius.card),
                    ),
                  ),
                  onPressed: () async {
                    String formatted = DateFormat(
                      'yyyy-MM-dd',
                    ).format(selectedDate);
                    await updateField('dob', formatted);
                    onUpdate();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: AppFontSizes.subtitle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
