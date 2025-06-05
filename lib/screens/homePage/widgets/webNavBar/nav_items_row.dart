

import 'package:flutter/material.dart';
import 'nav_item.dart';

class NavItemsRow extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onSearchPressed;
  final void Function(String) onNavigate;
  final VoidCallback onProfileTap;

  const NavItemsRow({
    super.key,
    required this.currentIndex,
    required this.onSearchPressed,
    required this.onNavigate,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavItem(
          label: 'Home',
          isActive: currentIndex == 0,
          onTap: () => onNavigate('/home'),
        ),
        NavItem(
          label: 'Search',
          isActive: currentIndex == 1,
          onTap: onSearchPressed,
        ),
        NavItem(
          label: 'Wishlist',
          isActive: currentIndex == 2,
          onTap: () => onNavigate('/wishlist'),
        ),
        NavItem(
          label: 'Profile',
          isActive: currentIndex == 3,
          onTap: onProfileTap,
        ),
      ],
    );
  }
}
