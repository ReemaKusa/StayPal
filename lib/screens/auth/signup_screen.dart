// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'email_verification_screen.dart';
// import 'login_screen.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController nameCtrl = TextEditingController();
//   final TextEditingController emailCtrl = TextEditingController();
//   final TextEditingController passCtrl = TextEditingController();
//   final TextEditingController confirmPassCtrl = TextEditingController();
//
//   bool hidePassword = true;
//
//   @override
//   void dispose() {
//     nameCtrl.dispose();
//     emailCtrl.dispose();
//     passCtrl.dispose();
//     confirmPassCtrl.dispose();
//     super.dispose();
//   }
//
//   Future<void> signUpUser() async {
//     final name = nameCtrl.text.trim();
//     final email = emailCtrl.text.trim();
//     final pass = passCtrl.text.trim();
//     final confirmPass = confirmPassCtrl.text.trim();
//
//     if (name.isEmpty || email.isEmpty || pass.isEmpty || confirmPass.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all the fields')),
//       );
//       return;
//     }
//
//     if (pass != confirmPass) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Passwords do not match')),
//       );
//       return;
//     }
//
//     try {
//       final creds = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: pass);
//
//       await creds.user!.updateDisplayName(name);
//
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(creds.user!.uid)
//           .set({
//         'fullName': name,
//         'email': email,
//         'createdAt': Timestamp.now(),
//       });
//
//       await creds.user!.sendEmailVerification();
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const EmailVerificationScreen()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 40),
//                 const Text(
//                   'Create Account',
//                   textAlign: TextAlign.left,
//                   style: TextStyle(
//                     fontSize: 28,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 TextField(
//                   controller: nameCtrl,
//                   textInputAction: TextInputAction.next,
//                   style: const TextStyle(color: Colors.black),
//                   decoration: _inputDecoration('Full Name'),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: emailCtrl,
//                   keyboardType: TextInputType.emailAddress,
//                   textInputAction: TextInputAction.next,
//                   style: const TextStyle(color: Colors.black),
//                   decoration: _inputDecoration('Email Address'),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: passCtrl,
//                   obscureText: hidePassword,
//                   textInputAction: TextInputAction.next,
//                   style: const TextStyle(color: Colors.black),
//                   decoration: _inputDecoration(
//                     'Password',
//                     isPassword: true,
//                     onToggle: () {
//                       setState(() {
//                         hidePassword = !hidePassword;
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: confirmPassCtrl,
//                   obscureText: hidePassword,
//                   style: const TextStyle(color: Colors.black),
//                   decoration: _inputDecoration(
//                     'Confirm Password',
//                     isPassword: true,
//                     onToggle: () {
//                       setState(() {
//                         hidePassword = !hidePassword;
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: signUpUser,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orangeAccent,
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     'Sign Up',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Already have an account?',
//                       style: TextStyle(color: Colors.black87),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const LoginScreen(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         'Log In',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.orangeAccent,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   InputDecoration _inputDecoration(
//       String hint, {
//         bool isPassword = false,
//         VoidCallback? onToggle,
//       }) {
//     return InputDecoration(
//       filled: true,
//       fillColor: Colors.white,
//       hintText: hint,
//       hintStyle: const TextStyle(color: Colors.black54),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.black12),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
//       ),
//       suffixIcon: isPassword
//           ? IconButton(
//         icon: Icon(
//           hidePassword ? Icons.visibility_off : Icons.visibility,
//           color: Colors.black12,
//         ),
//         onPressed: onToggle,
//       )
//           : null,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'email_verification_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  // Function to handle sign up logic
  Future<void> signUpUser() async {
    final fullName = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    final confirmPassword = confirmPasswordCtrl.text.trim();

    // Simple validation
    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      // Create the user
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null) {
        // Update user's display name
        await user.updateDisplayName(fullName);

        // Save user info to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': fullName,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Send email verification
        await user.sendEmailVerification();

        // Navigate to verification screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmailVerificationScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Full Name
                TextField(
                  controller: nameCtrl,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.black),
                  decoration: _inputDecoration('Full Name'),
                ),
                const SizedBox(height: 10),

                // Email
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.black),
                  decoration: _inputDecoration('Email Address'),
                ),
                const SizedBox(height: 10),

                // Password
                TextField(
                  controller: passwordCtrl,
                  obscureText: hidePassword,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.black),
                  decoration: _inputDecoration(
                    'Password',
                    isPassword: true,
                    onToggle: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Confirm Password
                TextField(
                  controller: confirmPasswordCtrl,
                  obscureText: hidePassword,
                  style: const TextStyle(color: Colors.black),
                  decoration: _inputDecoration(
                    'Confirm Password',
                    isPassword: true,
                    onToggle: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Sign Up Button
                ElevatedButton(
                  onPressed: signUpUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Link to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Input styling for all fields
  InputDecoration _inputDecoration(
      String hint, {
        bool isPassword = false,
        VoidCallback? onToggle,
      }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
      ),
      suffixIcon: isPassword
          ? IconButton(
        icon: Icon(
          hidePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.black12,
        ),
        onPressed: onToggle,
      )
          : null,
    );
  }
}