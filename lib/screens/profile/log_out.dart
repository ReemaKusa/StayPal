import 'package:flutter/material.dart';
import 'package:staypal/screens/auth/viewmodels/logout_viewmodel.dart';
import 'package:staypal/screens/profile/profile.dart';
//import 'package:staypal/screens/auth//logout.dart';
import 'package:staypal/screens/auth/views/logout_view.dart';


class LogOut extends StatelessWidget {
  const LogOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade50,
        elevation: 1,
        title: const Text(
          'Log Out',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyProfile()),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              const Text(
                'Are you sure you want to log out?',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  LogoutViewModel().logout(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Log Out', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}