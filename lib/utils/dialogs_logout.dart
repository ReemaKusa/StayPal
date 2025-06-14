import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/profile/viewmodels/profile_viewmodel.dart';
import 'package:staypal/screens/homePage/views/home_page.dart';

class DialogsUtil {
  static void showLogoutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLarge),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(AppSizes.spacingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                size: AppSizes.iconSizeLarge,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSizes.paddingMedium),
              const Text(
                'Are you sure you want to log out?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final profileVM = Provider.of<ProfileViewModel>(
                        context,
                        listen: false,
                      );
                      profileVM.reset();

                      await FirebaseAuth.instance.signOut();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
