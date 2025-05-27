import 'package:flutter/material.dart';
import 'package:staypal/viewmodels/security_settings_viewmodel.dart';

class SecuritySetting extends StatelessWidget {
  const SecuritySetting({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = SecuritySettingsViewModel();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Security Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: const Icon(Icons.lock_outline, color: Colors.black),
              title: const Text(
                'Change Password',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black,
              ),
              onTap: () => viewModel.showChangePasswordDialog(context),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: const Icon(Icons.email_outlined, color: Colors.black),
              title: const Text(
                'Reset Password via Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black,
              ),
              onTap: () => viewModel.sendResetEmail(context),
            ),
          ),
        ],
      ),
    );
  }
}