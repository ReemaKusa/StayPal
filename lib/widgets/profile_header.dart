import 'package:flutter/material.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';

class CustomProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final ImageProvider image;

  const CustomProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: image,
          radius: AppSizes.avatarRadius,
          backgroundColor: AppColors.grey,
        ),
        const SizedBox(width: AppSpacing.medium),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.subtitle,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              email,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: AppFontSizes.body,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
