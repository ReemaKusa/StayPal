import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staypal/utils/uploud_image.dart';
import 'package:staypal/screens/profile/views/personal_details.dart';
import 'package:staypal/screens/profile/views/payment_methods.dart';
import 'package:staypal/screens/profile/views/security_settings.dart';
import 'package:staypal/screens/profile/my_bookings_screen.dart';
import 'package:staypal/screens/wishlistPage/views/wishlist_view.dart';
import 'package:staypal/constants/app_constants.dart';

class ProfileViewModel extends ChangeNotifier {
  void reset() {
    _image = null;
    _userData = null;
    _isLoading = true;
    _selectedIndex = 3;
    notifyListeners();
  }

  Uint8List? _image;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  int _selectedIndex = 3;

  Uint8List? get image => _image;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  int get selectedIndex => _selectedIndex;

  Future<void> loadUserData() async {
    if (_userData != null && _userData!.isNotEmpty)
      return; // ✅ prevent reloading

    _isLoading = true;
    notifyListeners();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      _userData = doc.data();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> pickAndUploadProfileImage() async {
    Uint8List? selected = await pickImage(ImageSource.gallery);
    if (selected != null) {
      _image = selected;
      notifyListeners();

      final imageUrl = await uploadImageToFirebase(_image!);

      _userData = null;
      await loadUserData();
    }
  }

  ImageProvider get profileImage {
    if (_image != null) {
      return MemoryImage(_image!);
    } else if (_userData?['imageUrl'] != null &&
        _userData!['imageUrl'].toString().isNotEmpty) {
      return NetworkImage(_userData!['imageUrl']);
    } else {
      return const NetworkImage(AppConstants.defaultProfileImage);
    }
  }

  void onItemTapped(BuildContext context, int index) {
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    notifyListeners();

    final routes = ['/home', '/viewlisting', '/wishlist'];
    if (index < routes.length) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  void _navigateTo(BuildContext context, Widget destination) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
  }

  void navigateToPersonal(BuildContext context) =>
      _navigateTo(context, const PersonalDetails());

  void navigateToPayment(BuildContext context) =>
      _navigateTo(context, const PaymentMethods());

  void navigateToSecurity(BuildContext context) =>
      _navigateTo(context, const SecuritySetting());

  void navigateToBookings(BuildContext context) =>
      _navigateTo(context, const MyBookingsScreen());

  void navigateToWishlist(BuildContext context) =>
      _navigateTo(context, const WishListPage());
}
