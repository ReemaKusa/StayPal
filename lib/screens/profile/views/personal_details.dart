import 'package:flutter/material.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/profile/views/edit_address_screen.dart';
import 'package:staypal/screens/profile/views/edit_name_screen.dart';
import 'package:staypal/screens/profile/views/edit_phone_screen.dart';
import 'package:staypal/screens/profile/viewmodels/personal_details_viewmodel.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final viewModel = PersonalDetailsViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.fetchUserData().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'Personal Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSizes.title,
          ),
        ),
      ),
      body:
          viewModel.loading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                padding: EdgeInsets.all(AppPadding.formHorizontal),
                children: [
                  const Text(
                    "We'll remember this info to make it faster when you book.",
                    style: TextStyle(color: AppColors.grey),
                  ),
                  SizedBox(height: AppSpacing.large),
                  _buildTile("Name", viewModel.userData['fullName'] ?? '', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditNameScreen()),
                    ).then(
                      (_) => viewModel.fetchUserData().then(
                        (_) => setState(() {}),
                      ),
                    );
                  }),
                  _buildTile("Gender", viewModel.userData['gender'] ?? '', () {
                    viewModel.selectGender(context, () => setState(() {}));
                  }),
                  _buildTile(
                    "Date of birth",
                    viewModel.userData['dob'] ?? '',
                    () {
                      viewModel.pickDateOfBirth(context, () => setState(() {}));
                    },
                  ),
                  SizedBox(height: AppSpacing.large),
                  const Text(
                    'Contact details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.subtitle,
                    ),
                  ),
                  SizedBox(height: AppSpacing.small),
                  Text(
                    "Properties or providers you book with will use this info if they need to contact you.",
                  ),
                  SizedBox(height: AppSpacing.medium),
                  _buildTile(
                    "Email",
                    viewModel.userData['email'] ?? 'N/A',
                    null,
                  ),
                  _buildTile(
                    "Phone number",
                    viewModel.userData['phone'] ?? '',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditPhoneScreen(),
                        ),
                      ).then(
                        (_) => viewModel.fetchUserData().then(
                          (_) => setState(() {}),
                        ),
                      );
                    },
                  ),
                  _buildTile(
                    "Address",
                    viewModel.userData['address'] ?? '',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  EditAddressScreen(),
                        ),
                      ).then(
                        (_) => viewModel.fetchUserData().then(
                          (_) => setState(() {}),
                        ),
                      );
                    },
                  ),
                ],
              ),
    );
  }

  Widget _buildTile(String label, dynamic value, VoidCallback? onTap) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontSize: AppFontSizes.subtitle,
        ),
      ),
      subtitle: Text(value != null ? value.toString() : ''),
      trailing:
          onTap != null
              ? const Icon(
                Icons.arrow_forward_ios,
                size: AppIconSizes.smallIcon,
                color: AppColors.primary,
              )
              : null,
      onTap: onTap,
    );
  }
}
