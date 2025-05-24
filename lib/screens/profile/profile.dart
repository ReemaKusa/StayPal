import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/screens/profile/log_out.dart';
import 'package:staypal/screens/profile/my_fav.dart';
import 'package:staypal/screens/profile/my_bookings_screen.dart';
import 'package:staypal/screens/profile/payment_methods.dart';
import 'package:staypal/screens/profile/personal_details.dart';
import 'package:staypal/screens/profile/security_settings.dart';
import 'uploud_image.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Uint8List? _image;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (doc.exists) {
      setState(() {
        userData = doc.data();
        isLoading = false;
      });
    }
  }

  Future<void> selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });

      String imageUrl = await uploadImageToFirebase(image);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'imageUrl': imageUrl});
      await loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 30.0, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 30.0, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 65.0,
                          backgroundImage:
                              _image != null
                                  ? MemoryImage(_image!)
                                  : (userData?['imageUrl'] != null &&
                                              userData!['imageUrl']
                                                  .toString()
                                                  .isNotEmpty
                                          ? NetworkImage(userData!['imageUrl'])
                                          : NetworkImage(
                                            'https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3407.jpg',
                                          ))
                                      as ImageProvider,
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: Icon(Icons.photo_camera),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      userData?['fullName'] ?? 'No Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 16, 15, 15),
                      ),
                    ),
                    Text(
                      userData?['email'] ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 30),

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

                    _buildCard('My Favorite', Icons.favorite, MyFav()),
                    //تحويل لبوكننج انتباههه


                    _buildCard('My Bookings', Icons.event_available, const MyBookingsScreen()),
                    _buildCard(
                      'Security Settings',
                      Icons.lock,
                      SecuritySetting(),
                    ),

                    //تحويل لوج اوت انتباههه
                    _buildCard('Log Out', Icons.exit_to_app, LogOut()),
                  ],
                ),
              ),
    );
  }

  Widget _buildCard(String title, IconData icon, Widget destination) {
    return SizedBox(
      height: 80,
      child: Card(
        margin: EdgeInsets.all(10),
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon, color: Colors.black, size: 28),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
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
}
