
import 'package:flutter/material.dart';
import 'package:staypal/constants/color_constants.dart';


class LogoTitle extends StatelessWidget {
  final VoidCallback onTap;

  const LogoTitle({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Text(
        'StayPal',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
