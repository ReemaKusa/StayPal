import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Uint8List?> pickImage(ImageSource source) async {
  final picker = ImagePicker();
  final file = await picker.pickImage(source: source);
  return file != null ? await file.readAsBytes() : null;
}

Future<String> uploadImageToFirebase(Uint8List imageBytes) async {
  final user = FirebaseAuth.instance.currentUser;
  final ref = FirebaseStorage.instance
      .ref()
      .child('profileImages')
      .child('${user!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

  final UploadTask uploadTask = ref.putData(imageBytes);
  final  TaskSnapshot snapshot  = await uploadTask;
  final downloadUrl = await snapshot.ref.getDownloadURL();

  return downloadUrl;
}
