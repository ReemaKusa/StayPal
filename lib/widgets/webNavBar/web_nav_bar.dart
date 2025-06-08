import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/screens/auth/views/auth_entry_view.dart';
import 'logo_title.dart';
import'nav_items_row.dart';
import'actions_row.dart';

class WebNavBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final GlobalKey? searchKey;
  final VoidCallback? onSearchPressed;

  const WebNavBar({
    super.key,
    this.currentIndex = 0,
    this.searchKey,
    this.onSearchPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LogoTitle(onTap: () => _navigateTo(context, '/home')),
          NavItemsRow(
            currentIndex: currentIndex,
            onSearchPressed: () => _handleSearchNavigation(context),
            onNavigate: (route) => _navigateTo(context, route),
            onProfileTap: () => _handleProfileNavigation(context),
          ),
          ActionsRow(
            currentIndex: currentIndex,
            onSearchTap: () => _handleSearchNavigation(context),
            onProfileTap: () => _handleProfileNavigation(context),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  void _handleSearchNavigation(BuildContext context) {
    if (currentIndex == 0 && onSearchPressed != null) {
      onSearchPressed!();
    } else if (currentIndex == 0 && searchKey?.currentContext != null) {
      Scrollable.ensureVisible(
        searchKey!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      Future.delayed(const Duration(milliseconds: 100), () {
        if (searchKey?.currentContext != null) {
          Scrollable.ensureVisible(
            searchKey!.currentContext!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _handleProfileNavigation(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _navigateTo(context, '/profile');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AuthEntryView()),
      );
    }
  }
}
