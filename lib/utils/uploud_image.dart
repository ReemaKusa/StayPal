import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  debugPrint('No Image Selected');
  return null;
}

Future<String> uploadImageToFirebase(Uint8List image) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('profileImages')
      .child('$userId.jpg');

  firebase_storage.UploadTask uploadTask = ref.putData(image);
  firebase_storage.TaskSnapshot snapshot = await uploadTask;
  final downloadUrl = await snapshot.ref.getDownloadURL();

  await FirebaseAuth.instance.currentUser!.updatePhotoURL(downloadUrl);

  await FirebaseFirestore.instance.collection('users').doc(userId).set({
    'imageUrl': downloadUrl,
  }, SetOptions(merge: true));

  return downloadUrl;
}