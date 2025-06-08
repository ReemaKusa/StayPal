import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/user_model.dart';
import 'package:staypal/screens/admin/services/user_service.dart';

class ListUsersViewModel extends ChangeNotifier {
  final userService = UserService();
  final TextEditingController searchCtrl = TextEditingController();
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];
  bool isSearching = false;

  ListUsersViewModel() {
    searchCtrl.addListener(onSearchChanged);
    loadUsers();
  }

  void onSearchChanged() {
    final query = searchCtrl.text.toLowerCase().trim();
    filteredUsers =
        allUsers.where((user) {
          return user.fullName.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query) ||
              user.phone.toLowerCase().contains(query);
        }).toList();
    notifyListeners();
  }

  Future<void> loadUsers() async {
    allUsers = await userService.fetchUsers();
    filteredUsers = allUsers;
    notifyListeners();
  }

  Future<void> deleteUser(BuildContext context, UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,

      builder:
          (ctx) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            ),

            backgroundColor: AppColors.white,
            child: Padding(
              padding: EdgeInsets.all(AppPadding.containerPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Confirm Deletion',
                    style: TextStyle(
                      fontSize: AppFontSizes.subtitle,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  const Text(
                    'Are you sure you want to delete this user?This action cannot be undone.',
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      color: AppColors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.large),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.buttonVertical
                            ),
                            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
                          ),

                          child: const Text('Cancel'),
                        ),
                      ),

                      SizedBox(width: AppSpacing.betweenButtons),
                      Expanded(
                        child: ElevatedButton(
                          
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.buttonVertical,
                            ),
                             shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
                          ),

                          child: Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        
        const SnackBar(content: Text('User deleted successfully',
        style: TextStyle(fontSize: AppFontSizes.bottonfont,
        fontWeight: FontWeight.bold,color: AppColors.primary),
        
        
        ),backgroundColor: AppColors.white,),
      );
      loadUsers();
    }
  }

  void toggleSearch() {
    isSearching = !isSearching;
    if (!isSearching) searchCtrl.clear();
    notifyListeners();
  }

  void disposeController() {
    searchCtrl.dispose();
  }
}
