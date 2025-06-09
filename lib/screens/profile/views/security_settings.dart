import 'package:flutter/material.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/profile/viewmodels/security_settings_viewmodel.dart';

class SecuritySetting extends StatelessWidget {
  const SecuritySetting({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = SecuritySettingsViewModel();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'Security Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSizes.title,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.formHorizontal,
        ),
        children: [
         SizedBox(height: AppSpacing.large),
          _buildOptionTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () => viewModel.showChangePasswordDialog(context),
          ),
          const SizedBox(height: AppSpacing.medium),
          _buildOptionTile(
            icon: Icons.email_outlined,
            title: 'Reset Password via Email',
            
            onTap: () => viewModel.sendResetEmail(context),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyTransparent,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        leading: Icon(icon, color: AppColors.black),
        title: Text(
          title,
        ),
        trailing:  Icon(
          Icons.arrow_forward_ios,
          size: AppIconSizes.smallIcon,
          color: AppColors.primary,
        ),
        onTap: onTap,
      ),
    );
  }
}
