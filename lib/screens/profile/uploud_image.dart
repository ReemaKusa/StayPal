import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  print('No Image Selected');
  return null;
}

Future<String> uploadImageToFirebase(Uint8List image) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final ref = FirebaseStorage.instance
      .ref()
      .child('profileImages')
      .child('$userId.jpg');

  UploadTask uploadTask = ref.putData(image);
  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}
