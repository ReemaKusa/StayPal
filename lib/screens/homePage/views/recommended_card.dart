import 'package:flutter/material.dart';
import '../../search_result/event/views/event_details_view.dart';
import '../../search_result/hotel/views/hotel_details_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String id;
  final bool isFavorite;
  final String type;
  final bool isWeb;

  const RecommendedCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.id,
    required this.isFavorite,
    required this.type,
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
            Container(
              width: MediaQuery.of(context).size.width * (isWeb ? 0.2 : 0.3),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(width: isWeb ? 20 : 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: isWeb ? 16 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isWeb ? 18 : 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isWeb ? 8 : 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isWeb ? 16 : 14),
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

      if (type.toLowerCase() == 'hotel') {
        final doc = await FirebaseFirestore.instance.collection('hotel').doc(id).get();
        Navigator.of(context).pop();
        
        if (doc.exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HotelDetailsPage(
                hotel: doc.data() ?? {},
                hotelId: id,
                isInitiallyLiked: isFavorite,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Hotel details not found')),
          );
        }
      } else {
        final doc = await FirebaseFirestore.instance.collection('event').doc(id).get();
        Navigator.of(context).pop();
        
        if (doc.exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventDetailsPage(
                event: doc.data() ?? {},
                eventId: id,
                isInitiallyLiked: isFavorite,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event details not found')),
          );
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}