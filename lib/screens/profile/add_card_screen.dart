/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/widgets/visa_card.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _numberCtrl.addListener(() => setState(() {}));
    _nameCtrl.addListener(() => setState(() {}));
    _expiryCtrl.addListener(() => setState(() {}));
  }

  Future<void> saveCard() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    if (_numberCtrl.text.replaceAll(' ', '').length != 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card number must be 16 digits.')),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .add({
          'cardholder': _nameCtrl.text.trim(),
          'number': _numberCtrl.text.trim(),
          'expiry': _expiryCtrl.text.trim(),
          'cvv': _cvvCtrl.text.trim(),
        });

    Navigator.pop(context);
  }

  Widget _buildCardPreview() {
    return PaymentCardWidget(
      cardNumber: _numberCtrl.text,
      cardHolder: _nameCtrl.text,
      expiryDate: _expiryCtrl.text,
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

  @override
  Widget build(BuildContext context) {
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
            _buildCardPreview(),
            _buildInputField(
              _numberCtrl,
              'Card Number',
              keyboardType: TextInputType.number,
              maxLength: 19,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
                CardNumberInputFormatter(),
              ],
            ),
            _buildInputField(_nameCtrl, 'Name On Card'),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    _expiryCtrl,
                    'Expiry Date',
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    inputFormatters: [ExpiryDateInputFormatter()],
                  ),
                ),
                const SizedBox(width: AppSpacing.large),
                Expanded(
                  child: _buildInputField(
                    _cvvCtrl,
                    'CVV',
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 200),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.buttonVertical,
                  ),
                  side: BorderSide(color: AppColors.greyTransparent),
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
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digits.length) buffer.write(' ');
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 4) text = text.substring(0, 4);
    String newText = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2) newText += '/';
      newText += text[i];
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}*/
