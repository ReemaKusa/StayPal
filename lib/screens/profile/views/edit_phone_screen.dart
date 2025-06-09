import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/profile/viewmodels/edit_phone_viewmodel.dart';

class EditPhoneScreen extends StatelessWidget {
  const EditPhoneScreen({super.key});

  OutlineInputBorder _inputBorder(FocusNode focusNode) => OutlineInputBorder(
    borderSide: BorderSide(
      color: focusNode.hasFocus ? AppColors.primary : AppColors.grey,
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
      create: (_) => EditPhoneViewModel(),
      builder: (context, _) {
        final viewModel = context.watch<EditPhoneViewModel>();

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            title: Text(
              'Phone Number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.title,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(AppPadding.formHorizontal),
            child: Column(
              children: [
                TextField(
                  controller: viewModel.phoneController,
                  focusNode: viewModel.phoneFocus,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration(
                    'Phone Number',
                    viewModel.phoneFocus,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => viewModel.savePhone(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
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
