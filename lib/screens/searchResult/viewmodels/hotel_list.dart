import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './search_result_view_model.dart';
import '../../detailspage/hotel/views/hotel_details_view.dart';
import 'package:staypal/screens/notification/notification_viewmodel.dart';

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

            return Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.0,
                ),
              ),
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
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
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[100],
                            child: const Icon(Icons.hotel, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotelName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.orange[800],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  location,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey[600],
                        ),
                        onPressed: () async {
                          try {
                            await viewModel.toggleHotelLike(context, id, data);

                            if (!isLiked) {
                              final notificationViewModel = NotificationViewModel();
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
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        },
                      ),
                    ],
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
