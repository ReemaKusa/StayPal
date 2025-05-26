import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../screens/search_result/hotelDetails.dart';
import '../screens/search_result/eventDetails.dart';

class WishListViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateFormat _dateFormat = DateFormat('MMM d');

  Stream<List<QueryDocumentSnapshot>> get wishlistStream =>
      CombineLatestStream.combine2<QuerySnapshot, QuerySnapshot, List<QueryDocumentSnapshot>>(
        _firestore.collection('hotel').where('isFavorite', isEqualTo: true).snapshots(),
        _firestore.collection('event').where('isFavorite', isEqualTo: true).snapshots(),
        (hotelsSnap, eventsSnap) => [...hotelsSnap.docs, ...eventsSnap.docs],
      );

  String getImageUrl(dynamic images) {
    if (images is List && images.isNotEmpty) {
      return images.first.toString();
    } else if (images is String) {
      return images;
    }
    return '';
  }

  String getSubtitle(Map<String, dynamic> item, bool isHotel) {
    if (isHotel) {
      return item['location'] ?? '';
    } else {
      if (item['date'] is Timestamp) {
        return _dateFormat.format((item['date'] as Timestamp).toDate());
      }
      return item['date']?.toString() ?? '';
    }
  }

  void handleMenuSelection(
    BuildContext context,
    String value,
    DocumentReference reference,
    String? name,
  ) {
    if (value == 'remove') {
      reference.update({'isFavorite': false});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name removed from wishlist')),
      );
    } else if (value == 'share') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sharing $name...')),
      );
    }
  }

  void showDetailsBottomSheet(
    BuildContext context,
    Map<String, dynamic> item,
    bool isHotel,
    String id,
  ) {
    final imageUrl = getImageUrl(item['images']);
    final subtitle = getSubtitle(item, isHotel);
    final description = item['description'] ?? 'No description available';
    final price = item['price']?.toString();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SingleChildScrollView(
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
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image, color: Colors.grey)),
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
                          builder: (_) => HotelDetailsPage(
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
                          builder: (_) => EventDetailsPage(
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
