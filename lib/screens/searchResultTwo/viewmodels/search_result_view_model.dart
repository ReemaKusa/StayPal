import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../search_result/event/views/event_details_view.dart';
import '../../search_result/hotel/views/hotel_details_view.dart';
import '../../search_result/hotel/viewmodels/hotel_details_viewmodel.dart';

class SearchResultViewModel {
  bool showHotels = true;
  String? searchQuery;
  String? filterBy;

  final CollectionReference hotelsCollection = 
      FirebaseFirestore.instance.collection('hotel');
  final CollectionReference eventsCollection = 
      FirebaseFirestore.instance.collection('event');
  final CollectionReference wishlistCollection = 
      FirebaseFirestore.instance.collection('wishlist_testing');

  final Map<String, bool> _hotelLikes = {};
  final Map<String, bool> _eventLikes = {};

  Future<void> initializeLikes(BuildContext context) async {
    try {
      final snapshot = await wishlistCollection.get();
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final type = data['type'] as String?;
        if (type == 'hotel') _hotelLikes[doc.id] = true;
        if (type == 'event') _eventLikes[doc.id] = true;
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading favorites')));
    }
  }

  String _formatEventDate(dynamic date) {
    if (date == null) return 'No Date';
    if (date is Timestamp) return DateFormat('yyyy-MM-dd').format(date.toDate());
    if (date is String) return date;
    return 'Invalid Date';
  }

  Future<void> _toggleHotelLike(
    BuildContext context,
    String id,
    Map<String, dynamic> hotel,
  ) async {
    final currentStatus = hotel['isFavorite'] ?? false;
    final docRef = FirebaseFirestore.instance.collection('hotel').doc(id);

    try {
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({'isFavorite': !currentStatus});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Favorite status updated!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hotel not found.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status: $e')));
    }
  }

  Future<void> _toggleEventLike(
    BuildContext context,
    String id,
    Map<String, dynamic> event,
  ) async {
    final currentStatus = event['isFavorite'] ?? false;
    final docRef = FirebaseFirestore.instance.collection('event').doc(id);

    try {
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({'isFavorite': !currentStatus});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Favorite status updated!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event not found.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status: $e')));
    }
  }

  Widget buildHotelList(BuildContext context) {
    Query q = hotelsCollection;
    if (searchQuery != null && filterBy == 'location') {
      q = q.where('location', isEqualTo: searchQuery);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: q.snapshots(),
      builder: (ctx, snap) {
        if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return Center(
            child: Text(
              searchQuery == null 
                ? 'No hotels available' 
                : 'No hotels for "$searchQuery"',
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

            return _listingCard(
              context: context,
              title: data['name'] ?? 'No Name',
              subtitle: data['location'] ?? 'Unknown',
              price: data['price']?.toString() ?? 'N/A',
              imageUrl: imageUrl,
              isLiked: isLiked,
              onLike: () => _toggleHotelLike(context, id, data),
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

  Widget buildEventList(BuildContext context) {
    Query q = eventsCollection;
    if (searchQuery != null && filterBy == 'location') {
      q = q.where('location', isEqualTo: searchQuery);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: q.snapshots(),
      builder: (ctx, snap) {
        if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return Center(
            child: Text(
              searchQuery == null
                ? 'No events available'
                : 'No events for "$searchQuery"',
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

            return _listingCard(
              context: context,
              title: data['name'] ?? 'No Name',
              subtitle: date,
              price: data['price']?.toString() ?? 'N/A',
              imageUrl: imageUrl,
              isLiked: isLiked,
              onLike: () => _toggleEventLike(context, id, data),
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

  Widget _listingCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String price,
    required String imageUrl,
    required bool isLiked,
    required VoidCallback onLike,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: imageUrl.isEmpty
                  ? Container(
                      height: 100,
                      width: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.grey),
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$price ₪',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                  size: 28,
                ),
                onPressed: onLike,
              ),
            ),
          ],
        ),
      ),
    );
  }
}