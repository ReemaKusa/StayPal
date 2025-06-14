import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/profile/viewmodels/profile_viewmodel.dart';
import 'package:staypal/widgets/custom_nav_bar.dart';
import 'package:staypal/widgets/profile_avatar.dart';
import 'package:staypal/widgets/profile_option_tile.dart';
import 'package:staypal/utils/dialogs_logout.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProfileViewModel>(context, listen: false).loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSizes.title,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              size: AppIconSizes.appBarIcon,
              color: AppColors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 3),

      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppPadding.screenPadding),
                  child: Column(
                    children: [
                      ProfileAvatar(
                        imageProvider: viewModel.profileImage,
                        onImageTap: () => viewModel.pickAndUploadProfileImage(),
                      ),
                      const SizedBox(height: AppSpacing.large),
                      Text(
                        viewModel.userData?['fullName'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: AppFontSizes.subtitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        viewModel.userData?['email'] ?? '',
                        style: const TextStyle(
                          fontSize: AppFontSizes.body,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.large),
                      ProfileOptionTile(
                        label: 'Payment Methods',
                        icon: Icons.payment,
                        onTap: () => viewModel.navigateToPayment(context),
                      ),
                      ProfileOptionTile(
                        label: 'Personal Details',
                        icon: Icons.person,
                        onTap: () => viewModel.navigateToPersonal(context),
                      ),
                      ProfileOptionTile(
                        label: 'My Favorite',
                        icon: Icons.favorite,
                        onTap: () => viewModel.navigateToWishlist(context),
                      ),
                      ProfileOptionTile(
                        label: 'My Bookings',
                        icon: Icons.event_available,
                        onTap: () => viewModel.navigateToBookings(context),
                      ),
                      ProfileOptionTile(
                        label: 'Security Settings',
                        icon: Icons.lock,
                        onTap: () => viewModel.navigateToSecurity(context),
                      ),
                      ProfileOptionTile(
                        label: 'Log Out',
                        icon: Icons.logout,
                        onTap: () => DialogsUtil.showLogoutDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
