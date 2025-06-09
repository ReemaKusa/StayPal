import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/profile/viewmodels/edit_name_viewmodel.dart';

class EditNameScreen extends StatelessWidget {
  const EditNameScreen({super.key});

  OutlineInputBorder _inputBorder(FocusNode focusNode) => OutlineInputBorder(
        borderSide: BorderSide(
          color: focusNode.hasFocus ? AppColors.primary : AppColors.greyTransparent,
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.card),
      );

  InputDecoration _buildInputDecoration(String label, FocusNode focusNode) =>
      InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: AppColors.white,
        border: _inputBorder(focusNode),
        focusedBorder: _inputBorder(focusNode),
        enabledBorder: _inputBorder(focusNode),
      );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditNameViewModel(),
      builder: (context, _) {
        final viewModel = context.watch<EditNameViewModel>();

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            title: Text(
              'Edit Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.title,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppPadding.formHorizontal,
              right: AppPadding.formHorizontal,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: viewModel.firstNameCtrl,
                  focusNode: viewModel.firstNameFocus,
                  decoration: _buildInputDecoration('First Name *', viewModel.firstNameFocus),
                ),
                SizedBox(height: AppSpacing.medium),
                TextField(
                  controller: viewModel.lastNameCtrl,
                  focusNode: viewModel.lastNameFocus,
                  decoration: _buildInputDecoration('Last Name *', viewModel.lastNameFocus),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => viewModel.saveName(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    elevation: 3,
                    minimumSize: Size.fromHeight(AppPadding.buttonVertical * 3),
                    side: const BorderSide(color: AppColors.greyTransparent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.card),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.bottonfont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
