
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import './search_result_view_model.dart';
import './listing_card.dart';
import '../../search_result/event/views/event_details_view.dart';

class EventList extends StatelessWidget {
  final SearchResultViewModel viewModel;

  const EventList({required this.viewModel});

  String _formatEventDate(dynamic date) {
    if (date == null) return 'No Date';
    if (date is Timestamp) return DateFormat('yyyy-MM-dd').format(date.toDate());
    if (date is String) return date;
    return 'Invalid Date';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: viewModel.eventsCollection.snapshots(),
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

          if (viewModel.isNumericSearch) {
            final price = double.tryParse(viewModel.searchQuery!);
            if (price == null) return false;
            final itemPrice = data['price'] is num ? data['price'] as num : 0;
            return itemPrice <= price;
          }

          final name = (data['name']?.toString().toLowerCase() ?? '');
          final location = (data['location']?.toString().toLowerCase() ?? '');
          return name.contains(query) || location.contains(query);
        }).toList();

        if (docs.isEmpty) {
          return Center(
            child: Text(
              viewModel.searchQuery == null
                  ? 'No events available'
                  : 'No events found for "${viewModel.searchQuery}"',
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
            final date = _formatEventDate(data['date']);
            final isLiked = data['isFavorite'] ?? false;

            return ListingCard(
              title: data['name'] ?? 'No Name',
              subtitle: date,
              price: data['price']?.toString() ?? 'N/A',
              imageUrl: imageUrl,
              isLiked: isLiked,
              onLike: () => viewModel.toggleEventLike(context, id, data),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventDetailsPage(
                    event: data,
                    eventId: id,
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