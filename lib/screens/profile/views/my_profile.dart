import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staypal/screens/profile/log_out.dart';
import 'package:staypal/screens/profile/my_bookings_screen.dart';
import 'package:staypal/screens/profile/payment_methods.dart';
import 'package:staypal/screens/profile/personal_details.dart';
import 'package:staypal/screens/profile/security_settings.dart';
import 'package:staypal/screens/wishlistPage/wishlist_page.dart';
import 'package:staypal/screens/profile/views/payment_methods.dart';
import 'package:staypal/screens/profile/views/personal_details.dart';
import 'package:staypal/screens/profile/views/security_settings.dart';
import 'dart:typed_data';

import '../../wishlistPageTwo/views/wishlist_view.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../models/user_model.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final ProfileViewModel viewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.loadUserData().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              size: 28.0,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        currentIndex: viewModel.selectedIndex,
        onTap: (index) {
          viewModel.onItemTapped(context, index);
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 65.0,
                          backgroundImage: viewModel.getProfileImageProvider(),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () async {
                              await viewModel.selectImage();
                              setState(() {});
                            },
                            icon: const Icon(Icons.photo_camera),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      viewModel.userData?['fullName'] ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      viewModel.userData?['email'] ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    _buildCard(
                      'Payment Methods',
                      Icons.payment,
                      const PaymentMethods(),
                    ),
                    _buildCard(
                      'Personal Details',
                      Icons.person,
                      const PersonalDetails(),
                    ),
                    _buildCard(
                      'My Favorite',
                      Icons.favorite,
                      const WishListPage(),
                    ),
                    _buildCard(
                      'My Bookings',
                      Icons.event_available,
                      const MyBookingsScreen(),
                    ),
                    _buildCard(
                      'Security Settings',
                      Icons.lock,
                      const SecuritySetting(),
                    ),
                    _buildLogoutCard('Log Out', Icons.exit_to_app),
                  ],
                ),
              ),
    );
  }

  Widget _buildCard(String title, IconData icon, Widget destination) {
    return SizedBox(
      height: 70,

      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ListTile(
            leading: Icon(icon, color: Colors.black, size: 20),
            title: Text(title, style: const TextStyle(fontSize: 18.0)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutCard(String title, IconData icon) {
    return SizedBox(
      height: 70,
      child: Card(
        color: Colors.white,

        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 12.0),
          child: ListTile(
            leading: Icon(icon, color: Colors.black, size: 20),
            title: Text(title, style: const TextStyle(fontSize: 18.0)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              LogOut.show(context);
            },
          ),
        ),
      ),
    );
  }
}
