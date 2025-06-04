// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// //import 'package:staypal/screens/auth/auth_entry_screen.dart';
// import 'package:staypal/screens/auth/views/auth_entry_view.dart';
// class CustomNavBar extends StatelessWidget {
//   final int currentIndex;
//   final GlobalKey? searchKey; 
//   final VoidCallback? onSearchPressed;

//   const CustomNavBar({
//     super.key,
//     required this.currentIndex,
//     this.searchKey, 
//     this.onSearchPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       selectedItemColor: Colors.deepOrange,
//       unselectedItemColor: Colors.grey,
//       currentIndex: currentIndex,
//       onTap: (index) => _handleTap(context, index),
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.favorite),
//           label: 'Wishlist',
//         ),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//       ],
//     );
//   }

//   void _handleTap(BuildContext context, int index) {
//     if (index == currentIndex) return; 
    
//    switch (index) {
//       case 0: // Home
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/home',
//           (route) => false,
//         );
//         break;
        
//       case 1: // Search
//         if (currentIndex == 0) {
          
//           if (onSearchPressed != null) {
//             onSearchPressed!();
//           } else if (searchKey?.currentContext != null) {
//             Scrollable.ensureVisible(
//               searchKey!.currentContext!,
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeOut,
//             );
//           }
//         } else {
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             '/home',
//             (route) => false,
//           ).then((_) {
           
//             if (searchKey?.currentContext != null) {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 Scrollable.ensureVisible(
//                   searchKey!.currentContext!,
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeOut,
//                 );
//               });
//             }
//           });
//         }
//         break;
        
//       case 2: // Wishlist
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/wishlist',
//           (route) => false,
//         );
//         break;
        
//       case 3: // Profile
//         final user = FirebaseAuth.instance.currentUser;
//         if (user != null) {
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             '/profile',
//             (route) => false,
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AuthEntryView()),
//           );
//         }
//         break;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/screens/auth/views/auth_entry_view.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final GlobalKey? searchKey;
  final VoidCallback? onSearchPressed;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    this.searchKey,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0: // Home
        _navigateTo(context, '/home');
        break;
      case 1: // Search
        _handleSearchNavigation(context);
        break;
      case 2: // Wishlist
        _navigateTo(context, '/wishlist');
        break;
      case 3: // Profile
        _handleProfileNavigation(context);
        break;
    }
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (route) => false,
    );
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
      // First navigate to home
      _navigateTo(context, '/home');
      
      // Then handle the search focus
      WidgetsBinding.instance.addPostFrameCallback((_) {
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