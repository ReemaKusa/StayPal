
import 'package:flutter/material.dart';
import '../viewModel/splash_viewmodel.dart';  


class AnimatedLogo extends StatelessWidget {
  final SplashViewModel viewModel;

  const AnimatedLogo({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect
        AnimatedBuilder(
          animation: viewModel.logoScale,
          builder: (context, child) {
            return Transform.scale(
              scale: viewModel.logoScale.value * 1.3,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.08),
                ),
              ),
            );
          },
        ),

        // Logo container
        SlideTransition(
          position: viewModel.logoPosition,
          child: FadeTransition(
            opacity: viewModel.logoOpacity,
            child: ScaleTransition(
              scale: viewModel.logoScale,
              child: RotationTransition(
                turns: viewModel.logoRotation,
                child: const LogoWithEffects(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LogoWithEffects extends StatelessWidget {
  const LogoWithEffects({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Metallic border effect
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: -2,
                offset: const Offset(-5, -5),
              ),
            ],
          ),
        ),

        // Inner container with embossed effect
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.8),
                Colors.grey.shade100,
              ],
              stops: const [0.6, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(5, 5),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(-5, -5),
              ),
            ],
          ),
          child: const LogoImage(),
        ),

         Positioned(
          top: 10,
          left: 10,
          child: Transform.rotate(
            angle: -0.4,
            child: Container(
              width: 30,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        "assets/icon/flutter_app_logo_base.png",
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepOrange.shade100,
                  Colors.deepOrange.shade300,
                ],
              ),
            ),
            child: const Icon(
              Icons.hotel,
              size: 60,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
