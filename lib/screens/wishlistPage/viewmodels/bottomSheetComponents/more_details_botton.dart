
import 'package:flutter/material.dart';

class MoreDetailsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MoreDetailsButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          "More Details",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}