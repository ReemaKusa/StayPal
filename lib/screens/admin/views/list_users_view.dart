/*import 'package:flutter/material.dart';
import 'package:staypal/screens/admin/services/user_service.dart';
import 'package:staypal/models/user_model.dart';
import 'package:staypal/screens/admin/views/user_details_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/constants/app_constants.dart';

class ListUsersView extends StatefulWidget {
  const ListUsersView({super.key});

  @override
  State<ListUsersView> createState() => _ListUsersViewState();
}

class _ListUsersViewState extends State<ListUsersView> {
  final userService = UserService();
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];
  final TextEditingController _searchCtrl = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchCtrl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        return user.fullName.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query) ||
            user.phone.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _loadUsers() async {
    final users = await userService.fetchUsers();
    setState(() {
      _allUsers = users;
      _filteredUsers = users;
    });
  }

  Future<void> _deleteUser(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this user? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: AppColors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );

      _loadUsers();
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'User List',
                  style: TextStyle(fontSize: AppFontSizes.title, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.primary),
                onPressed: () {
                  setState(() => _isSearching = !_isSearching);
                  if (!_isSearching) _searchCtrl.clear();
                },
              )
            ],
          ),
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.medium, bottom: AppSpacing.section),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search by name, email, or phone',
                  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
    borderSide: const BorderSide(color: AppColors.primary),
  ),
                  
                 enabledBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.greyTransparent),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: AppSpacing.section),
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(child: Text('No users found.'))
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Card(
                        color: AppColors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: AppColors.greyTransparent),
                          borderRadius: BorderRadius.circular(AppBorderRadius.card),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: AppSpacing.cardVerticalMargin),
                        child: Padding(
                          padding: const EdgeInsets.all(AppPadding.horizontalPadding),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: user.imageUrl.isNotEmpty
                                    ? NetworkImage(user.imageUrl)
                                    : const NetworkImage(AppConstants.defaultProfileImage),
                              ),
                               SizedBox(width: AppSpacing.medium),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.fullName,
                                      style: const TextStyle(
                                        fontSize: AppFontSizes.subtitle,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                     SizedBox(height: AppSpacing.medium),
                                    Text(user.email, style: const TextStyle(color: AppColors.grey)),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: AppColors.black),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => UserDetailsView(user: user),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: AppColors.red),
                                    onPressed: () => _deleteUser(user),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
*/import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/admin/views/user_details_view.dart';
import 'package:staypal/screens/admin/viewmodels/list_users_viewmodel.dart';

class ListUsersView extends StatelessWidget {
  const ListUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListUsersViewModel(),
      child: Consumer<ListUsersViewModel>(
        builder: (context, viewModel, _) => Padding(
          padding: const EdgeInsets.all(AppPadding.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'User List',
                      style: TextStyle(fontSize: AppFontSizes.title, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: AppColors.primary),
                    onPressed: viewModel.toggleSearch,
                   
                  ),
                ],
              ),
              if (viewModel.isSearching)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.medium, bottom: AppSpacing.section),
                  child: TextField(
                    controller: viewModel.searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search by name, email, or phone',
                      
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                        borderSide:  BorderSide(color: AppColors.primary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.greyTransparent),
                        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: AppSpacing.section),
              Expanded(
                child: viewModel.filteredUsers.isEmpty
                    ? const Center(child: Text('No users found.'))
                    : ListView.builder(
                        itemCount: viewModel.filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = viewModel.filteredUsers[index];
                          return Card(
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: AppColors.greyTransparent),
                              borderRadius: BorderRadius.circular(AppBorderRadius.card),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: AppSpacing.cardVerticalMargin),
                            child: Padding(
                              padding: const EdgeInsets.all(AppPadding.horizontalPadding),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: user.imageUrl.isNotEmpty
                                        ? NetworkImage(user.imageUrl)
                                        : const NetworkImage(AppConstants.defaultProfileImage),
                                  ),
                                  const SizedBox(width: AppSpacing.medium),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.fullName,
                                          style: const TextStyle(
                                            fontSize: AppFontSizes.subtitle,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: AppSpacing.medium),
                                        Text(user.email, style: const TextStyle(color: AppColors.grey)),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: AppColors.black),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => UserDetailsView(user: user),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: AppColors.red),
                                        onPressed: () => viewModel.deleteUser(context, user),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
