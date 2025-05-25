// The Dynmaic V of the Wishlist P after the Static one was pushed

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import '../search_result/hotelDetails.dart';
import '../search_result/eventDetails.dart';
import '../homePage/custom_nav_bar.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateFormat _dateFormat = DateFormat('MMM d'); // Date formatter

  String _getImageUrl(dynamic images) {
    if (images is List && images.isNotEmpty) {
      return images.first.toString();
    } else if (images is String) {
      return images;
    }
    return '';
  }

  String _getSubtitle(Map<String, dynamic> item, bool isHotel) {
    if (isHotel) {
      return item['location'] ?? '';
    } else {
      // Handle Timestamp for events
      if (item['date'] is Timestamp) {
        return _dateFormat.format((item['date'] as Timestamp).toDate());
      }
      return item['date']?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomNavBar(
        currentIndex: 2, // Set correct index for each page
        // No need to pass searchKey
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'My Wishlist',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 28),
                  onPressed: () {},
                ),
                const Positioned(
                  right: 10,
                  top: 10,
                  child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: CombineLatestStream.combine2<
          QuerySnapshot,
          QuerySnapshot,
          List<QueryDocumentSnapshot>
        >(
          _firestore
              .collection('hotel')
              .where('isFavorite', isEqualTo: true)
              .snapshots(),
          _firestore
              .collection('event')
              .where('isFavorite', isEqualTo: true)
              .snapshots(),
          (hotelsSnap, eventsSnap) => [...hotelsSnap.docs, ...eventsSnap.docs],
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data ?? [];
          if (docs.isEmpty) {
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 8),
              ...docs.map((doc) {
                final item = doc.data() as Map<String, dynamic>;
                final imageUrl = _getImageUrl(item['images']);
                final isHotel = doc.reference.parent.id == 'hotel';
                final subtitle = _getSubtitle(item, isHotel);

                return GestureDetector(
                  onTap:
                      () => _showDetailsBottomSheet(
                        context,
                        item,
                        isHotel,
                        doc.id,
                      ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: Image.network(
                            imageUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
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
                                  item['name'] ?? 'No Name',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                if (item['price'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '${item['price']?.toString() ?? 'N/A'} ₪',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'remove') {
                              doc.reference.update({'isFavorite': false});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${item['name']} removed from wishlist',
                                  ),
                                ),
                              );
                            } else if (value == 'share') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Sharing ${item['name']}...'),
                                ),
                              );
                            }
                          },
                          itemBuilder:
                              (BuildContext context) => [
                                const PopupMenuItem(
                                  value: 'remove',
                                  child: Text('Remove'),
                                ),
                                const PopupMenuItem(
                                  value: 'share',
                                  child: Text('Share'),
                                ),
                              ],
                          icon: const Icon(Icons.more_vert, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  void _showDetailsBottomSheet(
    BuildContext context,
    Map<String, dynamic> item,
    bool isHotel,
    String id,
  ) {
    final imageUrl = _getImageUrl(item['images']);
    final subtitle = _getSubtitle(item, isHotel);
    final description = item['description'] ?? 'No description available';
    final price = item['price']?.toString();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item['name'] ?? 'No name',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 180,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(description, style: const TextStyle(fontSize: 16)),
                  if (price != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      '$price ₪',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (isHotel) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => HotelDetailsPage(
                                    hotel: item,
                                    hotelId: id,
                                    isInitiallyLiked: true,
                                  ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => EventDetailsPage(
                                    event: item,
                                    eventId: id,
                                    isInitiallyLiked: true,
                                  ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "More Details",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
