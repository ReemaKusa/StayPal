import 'package:flutter/material.dart';

import 'package:staypal/constants/color_constants.dart';

class NavItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? AppColors.primary : Colors.grey[600],
              ),
            ),
            if (isActive)
              Container(
                height: 2,
                width: 16,
                margin: const EdgeInsets.only(top: 8),
                color: AppColors.primary
              ),
          ],
        ),
      ),
    );
  }
}
