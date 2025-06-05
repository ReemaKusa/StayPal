

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './search_result_view_model.dart';
import './listing_card.dart';
import '../../search_result/hotel/views/hotel_details_view.dart';


class HotelList extends StatelessWidget {
  final SearchResultViewModel viewModel;

  const HotelList({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: viewModel.hotelsCollection.snapshots(),
      builder: (ctx, snap) {
        if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data!.docs.where((doc) {
          if (viewModel.searchQuery == null || viewModel.searchQuery!.isEmpty) {
            return true;
          }

          final data = doc.data() as Map<String, dynamic>;
          final query = viewModel.searchQuery!.toLowerCase();
          final name = (data['name']?.toString().toLowerCase() ?? '');
          final location = (data['location']?.toString().toLowerCase() ?? '');
          return name.contains(query) || location.contains(query);
        }).toList();

        if (docs.isEmpty) {
          return Center(
            child: Text(
              viewModel.searchQuery == null
                  ? 'No hotels available'
                  : 'No hotels found for "${viewModel.searchQuery}"',
            ),
          );
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (c, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>;
            final id = doc.id;
            final images = data['images'] is List ? data['images'] as List : [];
            final imageUrl = (images.isNotEmpty && images[0] != null)
                ? images[0].toString()
                : '';
            final isLiked = data['isFavorite'] ?? false;

            return ListingCard(
              title: data['name'] ?? 'No Name',
              subtitle: data['location'] ?? 'Unknown',
              price: data['price']?.toString() ?? 'N/A',
              imageUrl: imageUrl,
              isLiked: isLiked,
              onLike: () => viewModel.toggleHotelLike(context, id, data),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HotelDetailsPage(
                    hotel: data,
                    hotelId: id,
                    isInitiallyLiked: isLiked,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}