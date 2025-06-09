import 'package:flutter/material.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';

class ProfileAvatar extends StatelessWidget {
  final ImageProvider imageProvider;
  final VoidCallback onImageTap;

  const ProfileAvatar({
    super.key,
    required this.imageProvider,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: AppSizes.avatarRadius,
          backgroundImage: imageProvider,
          backgroundColor: AppColors.greyTransparent,
        ),
        Positioned(
          bottom: AppSpacing.xSmall,
          right: AppSpacing.small,
          child: GestureDetector(
            onTap: onImageTap,
            child: Container(
              padding: const EdgeInsets.all(AppPadding.iconPadding),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: AppColors.white,
                size: AppIconSizes.smallIcon,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
