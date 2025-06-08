import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:staypal/screens/auth/viewmodels/signup_viewmodel.dart';
import 'package:staypal/screens/auth/views/login_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final viewModel = SignUpViewModel();
  bool hidePassword = true;

  @override
  void dispose() {
    viewModel.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 500 : double.infinity,
                ),
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
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: viewModel.nameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: viewModel.inputDecoration('Full Name'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: viewModel.emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: viewModel.inputDecoration('Email Address'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: viewModel.passwordCtrl,
                      obscureText: hidePassword,
                      textInputAction: TextInputAction.next,
                      decoration: viewModel.passwordInputDecoration(
                        'Password',
                        hidePassword,
                            () => setState(() => hidePassword = !hidePassword),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: viewModel.confirmPasswordCtrl,
                      obscureText: hidePassword,
                      decoration: viewModel.passwordInputDecoration(
                        'Confirm Password',
                        hidePassword,
                            () => setState(() => hidePassword = !hidePassword),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => viewModel.signUpUser(context),
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginView()),
                            );
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(255, 87, 34, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (kIsWeb) ...[
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: const Text(
                          'Return to Home Page',
                          style: TextStyle(
                            color: Color.fromRGBO(255, 87, 34, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}