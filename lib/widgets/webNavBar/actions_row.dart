import 'package:flutter/material.dart';

class ActionsRow extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;

  const ActionsRow({
    super.key,
    required this.currentIndex,
    required this.onSearchTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          color: Colors.grey,
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/notifications',
            );
          },
        ),
      ],
    );
  }
}
