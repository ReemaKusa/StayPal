import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final bool isWeb;

  const HomeHeader({super.key, this.isWeb = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Find Events-Hotels",
              style: TextStyle(fontSize: isWeb ? 18 : 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              "Palestine",
              style: TextStyle(
                fontSize: isWeb ? 24 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (!isWeb)
          Stack(
            children: [
              const Icon(Icons.notifications_none, size: 28),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                ),
              ),
            ],
          ),
      ],
    );
  }
}