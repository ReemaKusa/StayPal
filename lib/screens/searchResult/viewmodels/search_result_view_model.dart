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

  final CollectionReference hotelsCollection = FirebaseFirestore.instance
      .collection('hotel');
  final CollectionReference eventsCollection = FirebaseFirestore.instance
      .collection('event');
  final CollectionReference wishlistCollection = FirebaseFirestore.instance
      .collection('wishlist_testing');

  final Map<String, bool> _hotelLikes = {};
  final Map<String, bool> _eventLikes = {};
  bool isNumericSearch = false;

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error loading favorites')));
    }
  }

  String _formatEventDate(dynamic date) {
    if (date == null) return 'No Date';
    if (date is Timestamp)
      return DateFormat('yyyy-MM-dd').format(date.toDate());
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Favorite status updated!')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Hotel not found.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status: $e')),
      );
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Favorite status updated!')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Event not found.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status: $e')),
      );
    }
  }

  Widget buildHotelList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: hotelsCollection.snapshots(),
      builder: (ctx, snap) {
        if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs =
            snap.data!.docs.where((doc) {
              if (searchQuery == null || searchQuery!.isEmpty) return true;

              final data = doc.data() as Map<String, dynamic>;
              final query = searchQuery!.toLowerCase();

              final name = (data['name']?.toString().toLowerCase() ?? '');
              final location =
                  (data['location']?.toString().toLowerCase() ?? '');

              return name.contains(query) || location.contains(query);
            }).toList();

        if (docs.isEmpty) {
          return Center(
            child: Text(
              searchQuery == null
                  ? 'No hotels available'
                  : 'No hotels found for "$searchQuery"',
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
            final imageUrl =
                (images.isNotEmpty && images[0] != null)
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
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => HotelDetailsPage(
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
  return StreamBuilder<QuerySnapshot>(
    stream: eventsCollection.snapshots(),
    builder: (ctx, snap) {
      if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
      if (snap.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      final docs = snap.data!.docs.where((doc) {
        if (searchQuery == null || searchQuery!.isEmpty) return true;

        final data = doc.data() as Map<String, dynamic>;
        final query = searchQuery!.toLowerCase();


        if (isNumericSearch) {
          final price = double.tryParse(searchQuery!);
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
            searchQuery == null
                ? 'No events available'
                : 'No events found for "$searchQuery"',
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
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    imageUrl.isEmpty
                        ? Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        )
                        : CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder:
                              (_, __) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: onLike,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle),
                    const SizedBox(height: 4),
                    Text(
                      '$price ₪',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
