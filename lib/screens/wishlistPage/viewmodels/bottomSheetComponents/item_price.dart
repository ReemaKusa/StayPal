

import 'package:flutter/material.dart';


class ItemPrice extends StatelessWidget {
  final String price;

  const ItemPrice({required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$price ₪',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.deepOrange,
      ),
    );
  }
}