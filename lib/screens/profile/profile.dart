import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/screens/profile/log_out.dart';
import 'package:staypal/screens/profile/my_bookings_screen.dart';
import 'package:staypal/screens/profile/payment_methods.dart';
import 'package:staypal/screens/profile/personal_details.dart';
import 'package:staypal/screens/profile/security_settings.dart';
import 'package:staypal/screens/wishlistPage/wishlist_page.dart';
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
  int _selectedIndex = 3;

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

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
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
              Icons.notifications,
              size: 30.0,
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(10.0),
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
                                          : const NetworkImage(
                                            'https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3407.jpg',
                                          ))
                                      as ImageProvider,
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.photo_camera),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      userData?['fullName'] ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 16, 15, 15),
                      ),
                    ),
                    Text(
                      userData?['email'] ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    _buildCard(
                      'Payment Methods',
                      Icons.payment,
                      PaymentMethods(),
                    ),
                    _buildCard(
                      'Personal Details',
                      Icons.person,
                      PersonalDetails(),
                    ),
                    _buildCard('My Favorite', Icons.favorite, WishListPage()),
                    _buildCard(
                      'My Bookings',
                      Icons.event_available,
                      MyBookingsScreen(),
                    ),
                    _buildCard(
                      'Security Settings',
                      Icons.lock,
                      SecuritySetting(),
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
          padding: EdgeInsets.symmetric(horizontal: 12.0),
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
