
import 'package:flutter/material.dart';

class TextAnimations {
  late Animation<double> opacity;
  late Animation<double> scale;

  void initAnimations(AnimationController controller) {
    opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeInOut),
      ),
    );

    scale = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );
  }
}