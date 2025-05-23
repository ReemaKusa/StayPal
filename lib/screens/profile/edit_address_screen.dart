import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({super.key});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _zipCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCurrentAddress();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Address",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Country/Region',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
              controller: TextEditingController(text: 'Palestine'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _addressCtrl,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
             SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _zipCtrl,
                    decoration: InputDecoration(
                      labelText: 'Zip Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _cityCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Town/City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: saveAddress,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
