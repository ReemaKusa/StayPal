import 'package:flutter/material.dart';
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
