import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staypal/utils/uploud_image.dart';

class ProfileViewModel {
  Uint8List? image;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  int selectedIndex = 3;

  Future<void> loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      userData = doc.data();
      isLoading = false;
    }
  }

  Future<void> selectImage() async {
    Uint8List? selectedImage = await pickImage(ImageSource.gallery);
    if (selectedImage != null) {
      image = selectedImage;
      String imageUrl = await uploadImageToFirebase(selectedImage);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'imageUrl': imageUrl});
      await loadUserData();
    }
  }

  void onItemTapped(BuildContext context, int index) {
    if (selectedIndex == index) return;
    selectedIndex = index;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/viewlisting');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/wishlist');
        break;
    }
  }

  ImageProvider getProfileImageProvider() {
    if (image != null) {
      return MemoryImage(image!);
    } else if (userData?['imageUrl'] != null &&
        userData!['imageUrl'].toString().isNotEmpty) {
      return NetworkImage(userData!['imageUrl']);
    } else {
      return const NetworkImage(
          'https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3407.jpg');
    }
  }
}