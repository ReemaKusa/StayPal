import 'package:flutter/material.dart';
import 'package:staypal/constants/color_constants.dart';
import '../viewModel/splash_viewmodel.dart';  

class SplashText extends StatelessWidget {
  final SplashViewModel viewModel;

  const SplashText({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: viewModel.textOpacity,
      child: ScaleTransition(
        scale: viewModel.textScale,
        child: Column(
          children: [
            Text(
              'StayPal',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Luxury stays, unforgettable experiences',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}