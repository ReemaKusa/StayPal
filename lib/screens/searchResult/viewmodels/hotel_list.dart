import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './search_result_view_model.dart';
import '../../view_details/hotel/views/hotel_details_view.dart';

class HotelList extends StatelessWidget {
  final SearchResultViewModel viewModel;

  const HotelList({Key? key, required this.viewModel}) : super(key: key);

  String _formatPrice(dynamic price) {
    if (price == null) return 'مجاناً';
    if (price is num) return '₪${price.toStringAsFixed(2)}';
    return price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: viewModel.hotelsCollection.snapshots(),
      builder: (ctx, snap) {
        if (snap.hasError) return Center(child: Text('خطأ: ${snap.error}'));
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
                  ? 'لا توجد فنادق متاحة'
                  : 'لا توجد نتائج لـ "${viewModel.searchQuery}"',
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
            final hotelName = data['name'] ?? 'بدون اسم';
            final location = data['location'] ?? 'موقع غير معروف';
            final price = _formatPrice(data['price']);

            return Card(
              elevation: 0, // Remove shadow
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.grey[300]!, // Light gray border
                  width: 1.0,
                ),
              ),
              color: Colors.white, // Pure white background
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
                            color: Colors.grey[100], // Lighter gray for error container
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
                                color: Colors.black87, // Darker text for better contrast
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
                                    color: Colors.grey[700], // Slightly darker gray
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
                                    color: Colors.grey[700], // Slightly darker gray
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
                          color: isLiked ? Colors.red : Colors.grey[600], // Darker gray for icon
                        ),
                        onPressed: () => viewModel.toggleHotelLike(context, id, data),
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