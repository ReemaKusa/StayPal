import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../viewmodels/wishlist_view_model.dart';
import './wish_list_item_card.dart';

class WishlistItemsList extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;
  final WishListViewModel viewModel;

  const WishlistItemsList({
    super.key,
    required this.docs,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        ...docs.map((doc) => WishlistItemCard(doc: doc, viewModel: viewModel)),
      ],
    );
  }
}