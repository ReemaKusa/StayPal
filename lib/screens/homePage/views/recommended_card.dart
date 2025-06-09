import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../detailsPage/event/views/event_details_view.dart';
import '../../detailsPage/hotel/views/hotel_details_view.dart';
import '../../../models/recommended_item_model.dart';

class RecommendedCard extends StatelessWidget {
  final RecommendedItemModel item;
  final bool isWeb;

  const RecommendedCard({
    super.key,
    required this.item,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: Container(
        height: isWeb ? 140.0 : 100.0,
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
                item.imageUrl,
                width: MediaQuery.of(context).size.width * (isWeb ? 0.2 : 0.3),
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                ),
              ),
            ),

            SizedBox(width: isWeb ? 20 : 12),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: isWeb ? 16 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isWeb ? 18 : 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isWeb ? 8 : 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isWeb ? 16 : 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(isWeb ? 20 : 12),
              child: Icon(
                Icons.arrow_forward_ios,
                size: isWeb ? 20 : 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToDetails(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final type = item.type.isEmpty ? _determineTypeFromTitle(item.title) : item.type.toLowerCase();

      if (type == 'hotel') {
        final doc = await FirebaseFirestore.instance.collection('hotel').doc(item.id).get();
        Navigator.of(context).pop();

        if (doc.exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HotelDetailsPage(
                hotel: doc.data() ?? {},
                hotelId: item.id,
                isInitiallyLiked: item.isFavorite,
              ),
            ),
          );
        } else {
          _showError(context, 'Hotel details not found');
        }
      } else {
        final doc = await FirebaseFirestore.instance.collection('event').doc(item.id).get();
        Navigator.of(context).pop();

        if (doc.exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventDetailsPage(
                event: doc.data() ?? {},
                eventId: item.id,
                isInitiallyLiked: item.isFavorite,
              ),
            ),
          );
        } else {
          _showError(context, 'Event details not found');
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showError(context, 'Error: ${e.toString()}');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 244, 105, 54),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _determineTypeFromTitle(String title) {
    const hotelKeywords = ['hotel', 'resort', 'inn', 'lodge', 'suite', 'villa'];
    final lowerTitle = title.toLowerCase();
    if (hotelKeywords.any((word) => lowerTitle.contains(word))) {
      return 'hotel';
    }
    return 'event';
  }
}
