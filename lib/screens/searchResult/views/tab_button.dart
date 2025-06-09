import 'package:flutter/material.dart';
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
            ? const Color.fromARGB(255, 255, 94, 0) 
            : Colors.orange.shade200, 
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
class TabButtons extends StatelessWidget {
  final bool showHotels;
  final VoidCallback onTabChanged;
  const TabButtons({
    Key? key,
    required this.showHotels,
    required this.onTabChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TabButton(
            label: 'Hotels',
            active: showHotels,
            onPressed: () {
              if (!showHotels) {
                onTabChanged();
              }
            },
          ),
          const SizedBox(width: 12),
          TabButton(
            label: 'Events',
            active: !showHotels,
            onPressed: () {
              if (showHotels) {
                onTabChanged();
              }
            },
          ),
        ],
      ),
    );
  }
}