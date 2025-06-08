import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/user_model.dart';
import 'package:staypal/screens/admin/views/edit_user_view.dart';

class UserDetailsView extends StatefulWidget {
  final UserModel user;
  const UserDetailsView({super.key, required this.user});

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  late bool isActive;
  late String userRole;

  @override
  void initState() {
    super.initState();
    isActive = widget.user.isActive;
    userRole = widget.user.role;
  }

  Future<void> _toggleUserActive(bool value) async {
    setState(() => isActive = value);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .update({'isActive': value});
  }

  Future<void> _toggleUserRole() async {
    final newRole = userRole == 'admin' ? 'user' : 'admin';

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .update({'role': newRole});

    setState(() {
      userRole = newRole;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('✅ Role updated to "$newRole"')));
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

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
                constraints: BoxConstraints(maxWidth: 600),
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
                        backgroundImage:
                            user.imageUrl.isNotEmpty
                                ? NetworkImage(user.imageUrl)
                                : const NetworkImage(
                                  AppConstants.defaultProfileImage,
                                ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildRow('Full Name', user.fullName),
                    _buildRow('Email', user.email),
                    _buildRow('Phone', user.phone),
                    _buildRow('Gender', user.gender),
                    _buildRow('DOB', user.dob),
                    const Divider(height: 32),
                    _buildRow('Address', user.address),
                    _buildRow('City', user.city),
                    _buildRow('Country', user.country),
                    _buildRow('Zip Code', user.zipCode),
                    const Divider(height: 32),
                    if (user.createdAt != null)
                      _buildRow(
                        'Created At',
                        user.createdAt!.toLocal().toString().split(" ")[0],
                      ),
                    const Divider(height: 32),
                    SwitchListTile(
                      title: const Text(
                        'User is Active',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: AppFontSizes.bottonfont),
                      ),
                      value: isActive,
                      onChanged: (val) {
                        setState(() {
                          isActive = val;
                        });
                      },
                      activeColor: AppColors.primary,
                      inactiveTrackColor: AppColors.greyTransparent,
                    ),
                    const Divider(height: 50),
                    Text(
                      'Current Role: $userRole',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                    icon: Icon(
                      Icons.edit_outlined,
                      size: AppIconSizes.tileIcon,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditUserView(user: user),
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
          Expanded(child: Text(value?.isNotEmpty == true ? value! : '-',
            style: const TextStyle(
              fontSize: AppFontSizes.bottonfont,
                              fontWeight: FontWeight.bold,

              color: Colors.black45
            ),)),
        ],
      ),
    );
  }
}
