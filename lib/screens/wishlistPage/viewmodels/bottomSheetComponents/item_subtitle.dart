import 'package:flutter/material.dart';


class ItemSubtitle extends StatelessWidget {
  final String subtitle;

  const ItemSubtitle({required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle, 
      style: TextStyle(color: Colors.grey[600]),
    );
  }
}