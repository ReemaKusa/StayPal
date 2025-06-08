
import 'package:flutter/material.dart';
import 'package:staypal/constants/color_constants.dart';

class TabButton extends StatelessWidget {

  final String label;
  final bool active;
  final VoidCallback onPressed;

  const TabButton({
    Key? key,
    required this.label,
    required this.active,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: active
            ? AppColors.primary
            : Colors.orange.shade200,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(label),
    );
  }
}
