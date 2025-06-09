// File 1: card_widget.dart
import 'package:flutter/material.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';

class PaymentCardWidget extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;

  const PaymentCardWidget({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    final last4 =
    cardNumber.replaceAll(' ', '').length >= 4
        ? cardNumber.replaceAll(' ', '').substring(cardNumber.replaceAll(' ', '').length - 4)
        : '****';


    return Container(
      width: double.infinity,
      height: 220,
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.card),
        image: const DecorationImage(
          image: AssetImage('assets/images/visa.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24,
            bottom: AppHeights.cardHeight,
            child: Text(
              '**** **** **** $last4',
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppFontSizes.title,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          Positioned(
            left: AppSizes.cardPositionVertical,
            bottom: AppSizes.cardPositionHorizantal,
            child: Text(
              cardHolder.isEmpty ? '' : cardHolder,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: AppFontSizes.subtitle,
              ),
            ),
          ),
          Positioned(
            right: AppSizes.cardPositionVertical,
            bottom: AppSizes.cardPositionHorizantal,
            child: Text(
              expiryDate.isEmpty ? '' : expiryDate,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: AppFontSizes.subtitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
