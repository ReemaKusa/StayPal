import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/user_model.dart';

class EditUserViewModel extends ChangeNotifier {
  final UserModel user;
  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final zipCtrl = TextEditingController();
  final countryCtrl = TextEditingController();

  final List<String> genders = ['Male', 'Female'];
  final List<String> roles = ['user', 'admin', 'hotel_manager', 'event_organizer'];

  String? selectedGender;
  String? selectedRole;

  EditUserViewModel(this.user) {
    nameCtrl.text = user.fullName;
    phoneCtrl.text = user.phone;
    cityCtrl.text = user.city;
    zipCtrl.text = user.zipCode;
    countryCtrl.text = user.country;
    selectedGender = user.gender;
    selectedRole = user.role;
  }

  void setRole(String? value) {
    selectedRole = value;
    notifyListeners();
  }

  void selectGender(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...genders.map((gender) => RadioListTile<String>(
                      title: Text(gender),
                      value: gender,
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setModalState(() => selectedGender = value);
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Save'),
                  ),
                )
              ],
            );
          },
        );
      },
    ).whenComplete(() => notifyListeners());
  }

  Future<void> updateUser(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final updatedData = {
      'fullName': nameCtrl.text,
      'phone': phoneCtrl.text,
      'city': cityCtrl.text,
      'gender': selectedGender ?? '',
      'zipCode': zipCtrl.text,
      'country': countryCtrl.text,
      'role': selectedRole ?? 'user',
      'updatedAt': DateTime.now(),
    };

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update(updatedData);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    cityCtrl.dispose();
    zipCtrl.dispose();
    countryCtrl.dispose();
    super.dispose();
  }
} 