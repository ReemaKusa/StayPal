import 'package:flutter/material.dart';
import '../viewModel/splash_viewmodel.dart';
import './splash_text.dart';
import './animated_logo.dart';
import './splash_loader.dart';
import './splash_background.dart';
//import '../../homePage/views/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SplashViewModel();
    _viewModel.initAnimations(this);
    _viewModel.addListener(_onViewModelChange);

    _viewModel.onAnimationComplete = _navigateToHome;
  }

  void _onViewModelChange() => setState(() {});

  void _navigateToHome() {
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => HomePage()),
    //   );
    // });
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const SplashBackground(),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedLogo(viewModel: _viewModel),
                const SizedBox(height: 40),
                SplashText(viewModel: _viewModel),
                const SizedBox(height: 40),

                if (_viewModel.model.showLoader)
                  SplashLoader(viewModel: _viewModel, width: size.width * 0.6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
