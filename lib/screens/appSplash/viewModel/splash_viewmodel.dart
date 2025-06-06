import 'package:flutter/material.dart';
import '../../../models/splash_model.dart';
import './animation_controller_manager.dart';
import './logo_animations.dart';
import './text_animations.dart';

class SplashViewModel with ChangeNotifier {
  SplashModel _model = SplashModel(
    startTime: DateTime.now(),
    showLoader: false,
    animationComplete: false,
  );

  SplashModel get model => _model;

  final AnimationControllerManager _controllerManager = AnimationControllerManager();
  final LogoAnimations _logoAnimations = LogoAnimations();
  final TextAnimations _textAnimations = TextAnimations();


  VoidCallback? onAnimationComplete;

  void initAnimations(TickerProvider vsync) {
    _controllerManager.initController(
      vsync,
      const Duration(milliseconds: 5800),
    );

    _logoAnimations.initAnimations(_controllerManager.controller);
    _textAnimations.initAnimations(_controllerManager.controller);

    _controllerManager.controller.addStatusListener(_handleAnimationStatus);
    _controllerManager.controller.forward();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _model = _model.copyWith(animationComplete: true);
      notifyListeners();
      // Trigger navigation callback
      onAnimationComplete?.call();
    } else if (_controllerManager.controller.value >= 0.8) {
      _model = _model.copyWith(showLoader: true);
      notifyListeners();
    }
  }

  // Getters for animations
  Animation<double> get logoScale => _logoAnimations.scale;
  Animation<double> get logoOpacity => _logoAnimations.opacity;
  Animation<Offset> get logoPosition => _logoAnimations.position;
  Animation<double> get logoRotation => _logoAnimations.rotation;
  Animation<double> get textOpacity => _textAnimations.opacity;
  Animation<double> get textScale => _textAnimations.scale;

  @override
  void dispose() {
    _controllerManager.dispose();
    super.dispose();
  }
}