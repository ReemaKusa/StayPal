import 'package:flutter/material.dart';
import 'package:staypal/constants/color_constants.dart';
import '../viewModel/splash_viewmodel.dart';  

class SplashLoader extends StatelessWidget {
  final SplashViewModel viewModel;
  final double width;

  const SplashLoader({
    super.key, 
    required this.viewModel, 
    required this.width
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: viewModel.model.showLoader ? 1 : 0,
      duration: const Duration(milliseconds: 800),
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            LinearProgressIndicator(
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 4,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 16),
            Text(
              'Preparing your experience...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}