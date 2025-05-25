import 'package:flutter/material.dart';
import 'package:staypal/screens/auth/logout.dart';

class LogOut {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                'Log Out',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'Are you sure you want to log out?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  signOutUser(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Log Out', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
