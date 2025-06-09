import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/user_model.dart';
import 'package:staypal/screens/admin/viewmodels/edit_user_modelview.dart';

class EditUserView extends StatelessWidget {
  final UserModel user;
  const EditUserView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditUserViewModel(user),
      child: Consumer<EditUserViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                'Edit User',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.title,
                ),
              ),
              backgroundColor: AppColors.white,
            ),
            body: Form(
              key: viewModel.formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppPadding.formVertical),
                children: [
                  _buildField(viewModel.nameCtrl, 'Full Name'),
                  _buildField(viewModel.phoneCtrl, 'Phone'),
                  _buildField(viewModel.cityCtrl, 'City'),
                  _buildGenderDropdown(context, viewModel),
                  _buildField(viewModel.zipCtrl, 'Zip Code'),
                  _buildField(viewModel.countryCtrl, 'Country'),
                  _buildRoleDropdown(viewModel),
                  const SizedBox(height: AppSpacing.large),
                  ElevatedButton(
                    onPressed: () => viewModel.updateUser(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.greyTransparent),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.card),
                      ),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.card),
            borderSide: const BorderSide(color: AppColors.greyTransparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.card),
            borderSide: const BorderSide(color: AppColors.greyTransparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.card),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildGenderDropdown(BuildContext context, EditUserViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: GestureDetector(
        onTap: () => viewModel.selectGender(context),
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Gender',
              hintText: viewModel.selectedGender ?? 'Select Gender',
              labelStyle: const TextStyle(color: AppColors.black),
              hintStyle: const TextStyle(color: AppColors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.card),
                borderSide: const BorderSide(color: AppColors.greyTransparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.card),
                borderSide: const BorderSide(color: AppColors.greyTransparent),
              ),
            ),
            controller: TextEditingController(text: viewModel.selectedGender),
            validator: (value) =>
                (viewModel.selectedGender == null || viewModel.selectedGender!.isEmpty)
                    ? 'Required'
                    : null,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown(EditUserViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: viewModel.roles.contains(viewModel.selectedRole)
            ? viewModel.selectedRole
            : viewModel.roles.first,
        decoration: InputDecoration(
          labelText: 'Role',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.card),
            borderSide: const BorderSide(color: AppColors.greyTransparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.card),
            borderSide: const BorderSide(color: AppColors.greyTransparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.card),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        items: viewModel.roles.map((role) {
          return DropdownMenuItem(
            value: role,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Text(
                role,
                style: const TextStyle(fontSize: AppFontSizes.subtitle),
              ),
            ),
          );
        }).toList(),
        onChanged: viewModel.setRole,
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
}