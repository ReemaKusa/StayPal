import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import './search_result_view_model.dart';
import '../../view_details/event/views/event_details_view.dart';
import 'package:staypal/screens/notification/notification_viewmodel.dart'; // تأكد من استيراد NotificationViewModel

class EventList extends StatelessWidget {
  final SearchResultViewModel viewModel;

  const EventList({Key? key, required this.viewModel}) : super(key: key);

  String _formatEventDate(dynamic date) {
    if (date == null) return 'No date';
    if (date is Timestamp) return DateFormat('yyyy-MM-dd').format(date.toDate());
    if (date is String) return date;
    return 'Invalid date';
  }

  String _formatPrice(dynamic price) {
    if (price == null) return 'Free';
    if (price is num) return '₪${price.toStringAsFixed(2)}';
    return price.toString();
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
            final price = _formatPrice(data['price']);
            final isLiked = data['isFavorite'] ?? false;
            final eventName = data['name'] ?? 'Unnamed Event';

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
                      builder: (_) => EventDetailsPage(
                        event: data,
                        eventId: id,
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
                            child: const Icon(Icons.event, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eventName,
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
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.orange[800],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  date,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '₪',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.orange[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  price.replaceAll('₪', ''),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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
                            // تحديث حالة الإعجاب
                            await viewModel.toggleEventLike(context, id, data);
                            
                            // إذا أصبح الحدث معجبًا به (القلب أحمر)
                            if (!isLiked) {
                              final notificationViewModel = NotificationViewModel();
                              notificationViewModel.addNotification(
                                title: 'New Like',
                                message: 'You liked $eventName event',
                                type: 'like',
                                actionRoute: '/event/$id',
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