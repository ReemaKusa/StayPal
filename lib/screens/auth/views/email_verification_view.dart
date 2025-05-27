import 'package:flutter/material.dart';
import 'package:staypal/screens/auth/viewmodels/email_verification_viewmodel.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  final viewModel = EmailVerificationViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Verify Your Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'We sent a verification email to your inbox. Once you’ve verified, tap the button below to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 40),
              OutlinedButton(
                onPressed: () => viewModel.resendVerificationEmail(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black12),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Resend Email',
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.checkVerification(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'I Verified My Email',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Need to switch accounts?', style: TextStyle(color: Colors.black87)),
                  TextButton(
                    onPressed: () => viewModel.signOutToLogin(context),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(255, 87, 34, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}