import 'package:flutter/material.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/utils/dialogs_logout.dart';

class HotelManagerDrawer extends StatelessWidget {
  const HotelManagerDrawer({super.key});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppPadding.horizontalPadding,
        AppSpacing.medium,
        AppPadding.horizontalPadding,
        AppSpacing.small,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppFontSizes.body,
          fontWeight: FontWeight.bold,
          color: AppColors.grey,
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.horizontalPadding,
        vertical: AppSpacing.xSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.card),
        border: Border.all(color: const Color.fromARGB(51, 230, 227, 227)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(31, 100, 100, 100),
            blurRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: AppIconSizes.tileIcon),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: AppIconSizes.smallIcon),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Hotel Manager',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSizes.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          _buildSectionTitle('Manage'),
          _buildOptionTile(
            icon: Icons.hotel,
            title: 'My Hotels',
            onTap: () => Navigator.pop(context),
          ),

          _buildSectionTitle('Activity'),
          _buildOptionTile(
            icon: Icons.reviews,
            title: 'My Reviews',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/my-reviews');
            },
          ),
          _buildOptionTile(
            icon: Icons.book_online,
            title: 'My Bookings',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/my-bookings');
            },
          ),

          _buildSectionTitle('Account'),
          _buildOptionTile(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () => DialogsUtil.showLogoutDialog(context),
          ),

          const SizedBox(height: AppSpacing.large),
        ],
      ),
    );
  }
}
