import 'package:flutter/material.dart';
import 'package:staypal/constants/color_constants.dart';
import '../../detailsPage/hotel/views/hotel_details_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/popular_hotels_model.dart';

class HotelCard extends StatelessWidget {
  final PopularHotelsModel hotel;
  final bool isWeb;

  const HotelCard({
    super.key,
    required this.hotel,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = isWeb ? 280.0 : 180.0;

    return GestureDetector(
      onTap: () => _navigateToHotelDetails(context),
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(right: isWeb ? 20 : 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
                  image: DecorationImage(
                    image: NetworkImage(hotel.imageUrl),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isWeb ? 12 : 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isWeb ? 18 : 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isWeb ? 6 : 4),
                  Text(
                    hotel.subtitle,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isWeb ? 16 : 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isWeb) ...[
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navigateToHotelDetails(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("View Hotel"),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToHotelDetails(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final doc = await FirebaseFirestore.instance.collection('hotel').doc(hotel.id).get();

      Navigator.of(context).pop();

      if (doc.exists) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HotelDetailsPage(
              hotel: doc.data() ?? {},
              hotelId: hotel.id,
              isInitiallyLiked: hotel.isFavorite,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hotel details not found')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}