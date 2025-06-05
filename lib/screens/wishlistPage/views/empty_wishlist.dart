import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:intl/intl.dart';
// import '../../search_result/hotel/views/hotel_details_view.dart';
// import '../../search_result/event/views/event_details_view.dart';
// import '../../homePage/widgets/custom_nav_bar.dart';
// import '../viewmodels/wishlist_view_model.dart';

class EmptyWishlistPlaceholder extends StatelessWidget {
  const EmptyWishlistPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the heart icon to add items',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}