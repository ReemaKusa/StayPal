import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class PersonalDetailsViewModel {
  Map<String, dynamic> userData = {};
  bool loading = true;
  String? selectedGender;

  Future<void> fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
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
      backgroundColor: Colors.white,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: 240,
              child: Column(
                children: [
                  RadioListTile<String>(
                    activeColor: Colors.deepOrange,
                    title: const Text("Male", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    value: 'Male',
                    groupValue: selectedGender,
                    onChanged: (value) => setModalState(() => selectedGender = value),
                  ),
                  RadioListTile<String>(
                    activeColor: Colors.deepOrange,
                    title:  Text("Female", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    value: 'Female',
                    groupValue: selectedGender,
                    onChanged: (value) => setModalState(() => selectedGender = value),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.deepOrange,
                      ),
                      onPressed: () async {
                        if (selectedGender != null) {
                          await updateField('gender', selectedGender);
                          onUpdate();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16)),
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime(2000),
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) => selectedDate = newDate,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    String formatted = DateFormat('yyyy-MM-dd').format(selectedDate);
                    await updateField('dob', formatted);
                    onUpdate();
                    Navigator.pop(context);
                  },
                  child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}