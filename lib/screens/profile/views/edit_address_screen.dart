import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/profile/viewmodels/edit_address_screen.dart';

class EditAddressScreen extends StatelessWidget {
  const EditAddressScreen({super.key});

  OutlineInputBorder _inputBorder(FocusNode focusNode) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color:
            focusNode.hasFocus ? AppColors.primary : AppColors.greyTransparent,
      ),
      borderRadius: BorderRadius.circular(AppBorderRadius.card),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditAddressViewModel(),
      builder: (context, _) {
        final viewModel = context.watch<EditAddressViewModel>();

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            title: Text(
              'Address',
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
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Country/Region',
                    labelStyle: TextStyle(color: AppColors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(AppBorderRadius.card),
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                  ),
                  style: TextStyle(color: AppColors.black),
                  controller: TextEditingController(text: 'Palestine'),
                ),
                SizedBox(height: AppSpacing.large),
                TextField(
                  controller: viewModel.addressCtrl,
                  focusNode: viewModel.addressFocus,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: AppColors.grey),
                    filled: true,
                    fillColor: AppColors.white,
                    border: _inputBorder(viewModel.addressFocus),
                    focusedBorder: _inputBorder(viewModel.addressFocus),
                    enabledBorder: _inputBorder(viewModel.addressFocus),
                  ),
                ),
                SizedBox(height: AppSpacing.large),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: viewModel.zipCtrl,
                        focusNode: viewModel.zipFocus,
                        decoration: InputDecoration(
                          labelText: 'Zip Code',
                          labelStyle: TextStyle(color: AppColors.grey),
                          filled: true,
                          fillColor: AppColors.white,
                          border: _inputBorder(viewModel.zipFocus),
                          focusedBorder: _inputBorder(viewModel.zipFocus),
                          enabledBorder: _inputBorder(viewModel.zipFocus),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.large),
                    Expanded(
                      child: TextField(
                        controller: viewModel.cityCtrl,
                        focusNode: viewModel.cityFocus,
                        decoration: InputDecoration(
                          labelText: 'Town/City',
                          labelStyle: TextStyle(color: AppColors.grey),
                          filled: true,
                          fillColor: AppColors.white,
                          border: _inputBorder(viewModel.cityFocus),
                          focusedBorder: _inputBorder(viewModel.cityFocus),
                          enabledBorder: _inputBorder(viewModel.cityFocus),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    minimumSize: Size.fromHeight(AppPadding.buttonVertical * 3),
                    side: BorderSide(color: AppColors.greyTransparent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.card),
                    ),
                  ),
                  onPressed: () => viewModel.saveAddress(context),
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.buttonVertical),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: AppFontSizes.bottonfont,
                        fontWeight: FontWeight.bold,
                      ),
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
