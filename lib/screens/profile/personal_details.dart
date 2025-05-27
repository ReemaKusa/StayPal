/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:staypal/screens/profile/edit_phone_screen.dart';
import 'edit_name_screen.dart';
import 'edit_address_screen.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  Map<String, dynamic>? userData;
  bool loading = true;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      setState(() {
        userData = doc.data();
        selectedGender = userData?['gender'];
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  Future<void> updateField(String field, dynamic value) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      field: value,
    });
    fetchUserData();
  }

  void selectGender() {
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
                    title: const Text(
                      "Male",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    value: 'Male',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setModalState(() => selectedGender = value);
                    },
                  ),
                  RadioListTile<String>(
                    activeColor: Colors.deepOrange,
                    title: const Text(
                      "Female",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    value: 'Female',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setModalState(() => selectedGender = value);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.deepOrange,
                      ),
                      onPressed: () async {
                        if (selectedGender != null) {
                          await updateField('gender', selectedGender);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 16),
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

  void pickDateOfBirth() {
    DateTime selectedDate = DateTime(2000);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
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
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    String formatted = DateFormat(
                      'yyyy-MM-dd',
                    ).format(selectedDate);
                    await updateField('dob', formatted);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Personal Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body:
          loading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Text(
                    'We\'ll remember this info to make it faster when you book.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(height: 20),
                  _buildTile(
                    "Name",
                    userData?['fullName'] ?? 'There is no name',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditNameScreen(),
                      ),
                    ).then((_) => fetchUserData()),
                  ),
                  _buildTile(
                    "Gender",
                    userData?['gender'].toString() ?? '',
                    selectGender,
                  ),
                  _buildTile(
                    "Date of birth",
                    userData?['dob'].toString() ?? '',
                    pickDateOfBirth,
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Contact details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Properties or providers you book with will use this info if they need to contact you.",
                  ),
                  const SizedBox(height: 20),
                  _buildTile(
                    "Email",
                    (userData?['email'] ?? 'N/A').toString(),
                    null,
                  ),
                  _buildTile(
                    "Phone number",
                    (userData?['phone'] ?? '').toString(),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditPhoneScreen(),
                      ),
                    ).then((_) => fetchUserData()),
                  ),

                  _buildTile(
                    "Address",
                    (userData?['address'] ?? '').toString(),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditAddressScreen(),
                      ),
                    ).then((_) => fetchUserData()),
                  ),
                ],
              ),
    );
  }

  Widget _buildTile(String label, String value, VoidCallback? onTap) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(value.toString()),
      trailing:
          onTap != null
              ? const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black,
              )
              : null,
      onTap: onTap,
    );
  }
}
*/