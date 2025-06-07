import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/profile/viewmodels/add_visa.dart';
import 'package:staypal/utils/input_formatter.dart';
import 'package:staypal/widgets/visa_card.dart';

class AddCardView extends StatelessWidget {
  const AddCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddCardViewModel(),
      child: const _AddCardForm(),
    );
  }
}

class _AddCardForm extends StatelessWidget {
  const _AddCardForm({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddCardViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        title: const Text(
          'Add Card',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: AppFontSizes.title,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.formHorizontal,
          vertical: AppPadding.formVertical,
        ),
        child: Column(
          children: [
            PaymentCardWidget(
              cardNumber: vm.numberCtrl.text,
              cardHolder: vm.nameCtrl.text,
              expiryDate: vm.expiryCtrl.text,
            ),
            const SizedBox(height: AppSpacing.large),

            _buildInputField(
              vm.numberCtrl,
              'Card Number',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
                CardNumberInputFormatter(),
              ],
              keyboardType: TextInputType.number,
              maxLength: 19,
            ),

            _buildInputField(vm.nameCtrl, 'Name On Card'),

            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    vm.expiryCtrl,
                    'Expiry Date',
                    inputFormatters: [ExpiryDateInputFormatter()],
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                  ),
                ),
                const SizedBox(width: AppSpacing.large),
                Expanded(
                  child: _buildInputField(
                    vm.cvvCtrl,
                    'CVV',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 200),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => vm.saveCard(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.buttonVertical,
                  ),
                  side: const BorderSide(color: AppColors.greyTransparent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.card),
                  ),
                ),
                child: const Text(
                  'Save Card',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSizes.bottonfont,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xSmall),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: AppColors.grey),
            filled: true,
            fillColor: AppColors.white,
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.card),
              borderSide: const BorderSide(color: AppColors.greyTransparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.card),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
      ],
    );
  }
}
