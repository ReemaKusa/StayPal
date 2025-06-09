import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './search_result_view_model.dart';
import '../../detailspage/hotel/views/hotel_details_view.dart';
import 'package:staypal/screens/notification/notification_viewmodel.dart';
import '../views/listing_card.dart';

class HotelList extends StatelessWidget {
  final SearchResultViewModel viewModel;
  final String currentUserId;

  const HotelList({
    Key? key,
    required this.viewModel,
    required this.currentUserId,
  }) : super(key: key);

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

        viewModel.setHotelResults(docs.map((doc) => doc.data() as Map<String, dynamic>).toList());

        if (docs.isEmpty) {
          return Center(
            child: Text(
              viewModel.searchQuery == null
                  ? 'No hotels available'
                  : 'No results for "${viewModel.searchQuery}"',
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final id = doc.id;
            final images = data['images'] is List ? data['images'] as List : [];
            final imageUrl = (images.isNotEmpty && images[0] != null)
                ? images[0].toString()
                : '';
            final isLiked = data['isFavorite'] ?? false;
            final hotelName = data['name'] ?? 'Unnamed Hotel';
            final location = data['location'] ?? 'Unknown location';
            final description = data['description'] ?? '';

            return ListingCard(
              title: hotelName,
              subtitle: location,
              description: description,
              imageUrl: imageUrl,
              isLiked: isLiked,
              onLike: () async {
                try {
                  await viewModel.toggleHotelLike(context, id, data);
                  final notificationViewModel = NotificationViewModel();
                  
                  if (!isLiked) {
                    await notificationViewModel.addNotification(
                      userId: currentUserId,
                      title: 'New Like',
                      message: 'You liked $hotelName hotel',
                      type: 'like',
                      actionRoute: '/hotel/$id',
                      targetName: hotelName,
                      targetId: id,
                      imageUrls: images.isNotEmpty
                          ? List<String>.from(images)
                          : [],
                    );
                  } else {
                    await notificationViewModel.removeLikeNotification(currentUserId, id);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HotelDetailsPage(
                      hotel: data,
                      hotelId: id,
                      isInitiallyLiked: isLiked,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}