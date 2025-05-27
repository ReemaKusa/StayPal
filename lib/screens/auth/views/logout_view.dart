import 'package:flutter/material.dart';
import 'package:staypal/screens/auth/viewmodels/logout_viewmodel.dart';

class LogoutView extends StatelessWidget {
  const LogoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = LogoutViewModel();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
        backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => viewModel.logout(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Log Out',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}