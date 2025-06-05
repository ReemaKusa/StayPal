import 'package:flutter/material.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';

class GlobalBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlobalBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      backgroundColor: AppColors.white,
      selectedFontSize: AppFontSizes.body,
      unselectedFontSize: AppFontSizes.body,
      items:  [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
