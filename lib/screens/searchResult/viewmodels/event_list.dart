import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import './search_result_view_model.dart';
import '../../detailspage/event/views/event_details_view.dart';
import 'package:staypal/screens/notification/notification_viewmodel.dart';
import '../views/listing_card.dart';

class EventList extends StatelessWidget {
  final SearchResultViewModel viewModel;
  final String currentUserId;

  const EventList({
    Key? key,
    required this.viewModel,
    required this.currentUserId,
  }) : super(key: key);

  String _formatEventDate(dynamic date) {
    if (date == null) return 'No date';
    if (date is Timestamp) return DateFormat('yyyy-MM-dd').format(date.toDate());
    if (date is String) return date;
    return 'Invalid date';
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

        viewModel.setEventResults(docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'name': data['name'] ?? 'Unnamed Event',
            'location': data['location'] ?? 'Location not specified',
            'price': data['price'] ?? 0,
            'date': _formatEventDate(data['date']),
            'description': data['description'] ?? '',
          };
        }).toList());

        if (docs.isEmpty) {
          return Center(
            child: Text(
              viewModel.searchQuery == null
                  ? 'No events available'
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
            final date = _formatEventDate(data['date']);
            final isLiked = data['isFavorite'] ?? false;
            final eventName = data['name'] ?? 'Unnamed Event';
            final description = data['description'] ?? '';
            final location = data['location'] ?? 'Location not specified';

            return ListingCard(
              title: eventName,
              subtitle: '$location • $date',
              description: description,
              imageUrl: imageUrl,
              isLiked: isLiked,
              onLike: () async {
                try {
                  await viewModel.toggleEventLike(context, id, data);
                  final notificationViewModel = NotificationViewModel();
                  
                  if (!isLiked) {
                    await notificationViewModel.addNotification(
                      userId: currentUserId,
                      title: 'New Like',
                      message: 'You liked $eventName event',
                      type: 'like',
                      actionRoute: '/event/$id',
                      targetName: eventName,
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
                    builder: (_) => EventDetailsPage(
                      event: data,
                      eventId: id,
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