import 'package:flutter/material.dart';
import 'package:staypal/screens/auth/viewmodels/auth_entry_viewmodel.dart';
import 'package:staypal/screens/auth/views/signup_view.dart';
import 'package:staypal/screens/auth/views/login_view.dart';

class AuthEntryView extends StatelessWidget {
  const AuthEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = AuthEntryViewModel();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/staypal_logo.png',
                height: 400,
                color: Colors.black,
              ),
              const SizedBox(height: 0),
              const Text(
                'Millions of places.\nBook your next stay!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => viewModel.goToSignUp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => viewModel.goToLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}