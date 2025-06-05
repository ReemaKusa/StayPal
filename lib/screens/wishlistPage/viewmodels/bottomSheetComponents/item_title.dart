
import 'package:flutter/material.dart';


class ItemTitle extends StatelessWidget {
  final String name;

  const ItemTitle({ required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }
}
