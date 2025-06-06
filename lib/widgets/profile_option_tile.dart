import 'package:flutter/material.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';

class ProfileOptionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileOptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xSmall),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyTransparent,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppPadding.cardPadding,
          vertical: AppPadding.iconPadding,
        ),
        leading: Icon(
          icon,
          color: AppColors.black,
          size: AppIconSizes.tileIcon,
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: AppFontSizes.subtitle,
            color: AppColors.black,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: AppIconSizes.smallIcon,
          color: AppColors.primary,
        ),
        onTap: onTap,
      ),
    );
  }
}
