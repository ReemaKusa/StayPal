import 'package:flutter/material.dart';
import 'package:staypal/constants/color_constants.dart';
import '../../detailsPage/event/views/event_details_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/upcoming_events_model.dart';

class EventCard extends StatelessWidget {
  final UpcomingEventsModel event;
  final bool isWeb;

  const EventCard({
    super.key,
    required this.event,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallPhone = screenWidth < 375;

    return GestureDetector(
      onTap: () => _navigateToEventDetails(context),
      child: Container(
        margin: EdgeInsets.only(bottom: isWeb ? 20 : 16),
        height: isWeb ? 200 : (isSmallPhone ? 140 : 160),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
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
              child: Container(
                width: isWeb ? 200 : (isSmallPhone ? 110 : 130),
                height: isWeb ? 200 : (isSmallPhone ? 140 : 160),
                child: Image.network(
                  event.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    child: Icon(Icons.image, size: 40, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isWeb ? 16.0 : 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isWeb ? 18 : (isSmallPhone ? 14 : 16),
                          ),
                        ),
                        SizedBox(height: isWeb ? 6 : 4),
                        Text(
                          event.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isWeb ? 14 : (isSmallPhone ? 11 : 12),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: isWeb ? 8.0 : 4.0),
                        child: Text(
                          event.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isWeb ? 14 : (isSmallPhone ? 11 : 12),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () => _navigateToEventDetails(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: Size(
                            isWeb ? 120 : (isSmallPhone ? 80 : 90),
                            isWeb ? 40 : (isSmallPhone ? 32 : 36),
                          ),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: isWeb ? 12 : (isSmallPhone ? 8 : 12),
                            vertical: isWeb ? 8 : 6,
                          ),
                        ),
                        child: Text(
                          isSmallPhone ? "Join" : "Join Event",
                          style: TextStyle(
                            fontSize: isWeb ? 14 : (isSmallPhone ? 12 : 13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToEventDetails(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final doc = await FirebaseFirestore.instance.collection('event').doc(event.id).get();
      Navigator.of(context).pop();

      if (doc.exists) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailsPage(
              event: doc.data() ?? {},
              eventId: event.id,
              isInitiallyLiked: event.isFavorite,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event details not found')),
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