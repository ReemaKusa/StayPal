import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/user_model.dart';
import 'package:staypal/screens/admin/viewmodels/user_details_viewmodel.dart';
import 'package:staypal/screens/admin/views/edit_user_view.dart';

class UserDetailsView extends StatelessWidget {
  final UserModel user;
  const UserDetailsView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserDetailsViewModel()..initialize(user),
      child: Consumer<UserDetailsViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: Text(
                'User Details',
                style: TextStyle(
                  fontSize: AppFontSizes.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: AppColors.white,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(AppPadding.screenPadding),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      padding: const EdgeInsets.all(AppPadding.containerPadding),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppBorderRadius.card),
                        boxShadow: [
                          BoxShadow(color: AppColors.greyTransparent, blurRadius: 12),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.medium),
                          Center(
                            child: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              radius: AppSizes.avatarRadius,
                              backgroundImage: viewModel.user.imageUrl.isNotEmpty
                                  ? NetworkImage(viewModel.user.imageUrl)
                                  : const NetworkImage(AppConstants.defaultProfileImage),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildRow('Full Name', viewModel.user.fullName),
                          _buildRow('Email', viewModel.user.email),
                          _buildRow('Phone', viewModel.user.phone),
                          _buildRow('Gender', viewModel.user.gender),
                          _buildRow('DOB', viewModel.user.dob),
                          const Divider(height: 32),
                          _buildRow('Address', viewModel.user.address),
                          _buildRow('City', viewModel.user.city),
                          _buildRow('Country', viewModel.user.country),
                          _buildRow('Zip Code', viewModel.user.zipCode),
                          const Divider(height: 32),
                          if (viewModel.user.createdAt != null)
                            _buildRow(
                              'Created At',
                              viewModel.user.createdAt!.toLocal().toString().split(" ")[0],
                            ),
                          const Divider(height: 32),
                          SwitchListTile(
                            title: const Text(
                              'User is Active',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSizes.bottonfont),
                            ),
                            value: viewModel.isActive,
                            onChanged: viewModel.toggleUserActive,
                            activeColor: AppColors.primary,
                            inactiveTrackColor: AppColors.greyTransparent,
                          ),
                          const Divider(height: 50),
                          Text(
                            'Current Role: ${viewModel.userRole}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () => viewModel.toggleUserRole(context),
                            child: const Text('Toggle Role'),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: AppIconSizes.tileIcon,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditUserView(user: viewModel.user),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.bottonfont,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(
                fontSize: AppFontSizes.bottonfont,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
