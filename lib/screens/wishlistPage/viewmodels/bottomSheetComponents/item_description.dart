import 'package:flutter/material.dart';


class ItemDescription extends StatelessWidget {
  final String description;

  const ItemDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description, 
      style: const TextStyle(fontSize: 16),
    );
  }
}