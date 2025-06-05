// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:staypal/screens/auth/views/email_verification_view.dart';
//
// class LoginViewModel {
//   final TextEditingController emailCtrl = TextEditingController();
//   final TextEditingController passwordCtrl = TextEditingController();
//
//   void disposeControllers() {
//     emailCtrl.dispose();
//     passwordCtrl.dispose();
//   }
//
//   Future<void> loginWithEmail(BuildContext context) async {
//     final email = emailCtrl.text.trim();
//     final password = passwordCtrl.text;
//
//     if (email.isEmpty || password.isEmpty) {
//       _showMessage(context, 'Please enter both email and password');
//       return;
//     }
//
//     try {
//       final credential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//       final user = credential.user;
//
//       if (user != null) {
//         await user.reload();
//         if (!user.emailVerified) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const EmailVerificationView()),
//           );
//           return;
//         }
//
//         await _redirectBasedOnRole(context, user.uid);
//       }
//     } on FirebaseAuthException catch (e) {
//       _showMessage(context, e.message ?? 'Login failed');
//     }
//   }
//
//   Future<void> loginWithGoogle(BuildContext context) async {
//     try {
//       final googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return;
//
//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       final userCredential =
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       final user = userCredential.user;
//
//       if (user != null) {
//         await _saveUserToFirestore(user);
//         await _redirectBasedOnRole(context, user.uid);
//       }
//     } catch (e) {
//       _showMessage(context, 'Google Sign-In error: $e');
//     }
//   }
//
//   Future<void> _saveUserToFirestore(User user) async {
//     final userRef =
//     FirebaseFirestore.instance.collection('users').doc(user.uid);
//     final doc = await userRef.get();
//     if (!doc.exists) {
//       await userRef.set({
//         'uid': user.uid,
//         'name': user.displayName ?? '',
//         'email': user.email ?? '',
//         'createdAt': FieldValue.serverTimestamp(),
//         'role': 'user', // Default role
//       });
//     }
//   }
//
//   Future<void> _redirectBasedOnRole(BuildContext context, String uid) async {
//     final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//
//     if (!userDoc.exists || !userDoc.data()!.containsKey('role')) {
//       _showMessage(context, 'User role not found.');
//       return;
//     }
//
//     final role = userDoc['role'];
//
//     switch (role) {
//       case 'admin':
//         Navigator.pushReplacementNamed(context, '/adminDashboard');
//         break;
//       case 'hotel_manager':
//         Navigator.pushReplacementNamed(context, '/hotelManagerHome');
//         break;
//       case 'event_organizer':
//         Navigator.pushReplacementNamed(context, '/eventOrganizerHome');
//         break;
//       default:
//         Navigator.pushReplacementNamed(context, '/userHome');
//         break;
//     }
//   }
//
//   void _showMessage(BuildContext context, String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }
//
//   InputDecoration inputDecoration(String hint) => InputDecoration(
//     hintText: hint,
//     filled: true,
//     fillColor: Colors.white,
//     hintStyle: const TextStyle(color: Colors.black54),
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: Colors.black12),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
//     ),
//   );
//
//   InputDecoration passwordInputDecoration(
//       String hint, bool isHidden, VoidCallback onToggle) {
//     return inputDecoration(hint).copyWith(
//       suffixIcon: IconButton(
//         icon: Icon(
//           isHidden ? Icons.visibility_off : Icons.visibility,
//           color: Colors.black26,
//         ),
//         onPressed: onToggle,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:staypal/screens/auth/views/email_verification_view.dart';

class LoginViewModel {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  void disposeControllers() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
  }

  Future<void> loginWithEmail(BuildContext context) async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage(context, 'Please enter both email and password');
      return;
    }

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user;

      if (user != null) {
        await user.reload();
        if (!user.emailVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const EmailVerificationView()),
          );
          return;
        }

        await _redirectBasedOnRole(context, user.uid);
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(context, e.message ?? 'Login failed');
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _saveUserToFirestore(user);
        await _redirectBasedOnRole(context, user.uid);
      }
    } catch (e) {
      _showMessage(context, 'Google Sign-In error: $e');
    }
  }

  Future<void> _saveUserToFirestore(User user) async {
    final userRef =
    FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await userRef.get();
    if (!doc.exists) {
      await userRef.set({
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'user', // Default role
      });
    }
  }

  Future<void> _redirectBasedOnRole(BuildContext context, String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!userDoc.exists || !userDoc.data()!.containsKey('role')) {
      _showMessage(context, 'User role not found.');
      return;
    }

    final role = userDoc['role'];

    switch (role) {
      case 'admin':
        Navigator.pushReplacementNamed(context, '/adminDashboard');
        break;
      case 'hotel_manager':
        Navigator.pushReplacementNamed(context, '/hotelManagerHome');
        break;
      case 'event_organizer':
        Navigator.pushReplacementNamed(context, '/eventOrganizerHome');
        break;
      default:
        return; // Let normal users stay in default flow (HomePage)
    }
  }

  void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  InputDecoration inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    hintStyle: const TextStyle(color: Colors.black54),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.black12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
    ),
  );

  InputDecoration passwordInputDecoration(
      String hint, bool isHidden, VoidCallback onToggle) {
    return inputDecoration(hint).copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          isHidden ? Icons.visibility_off : Icons.visibility,
          color: Colors.black26,
        ),
        onPressed: onToggle,
      ),
    );
  }
}