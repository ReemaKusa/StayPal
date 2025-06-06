
import 'package:flutter/material.dart';

class AnimationControllerManager {
  late final AnimationController controller;

  void initController(TickerProvider vsync, Duration duration) {
    controller = AnimationController(
      duration: duration,
      vsync: vsync,
    );
  }

  void dispose() {
    controller.dispose();
  }
}