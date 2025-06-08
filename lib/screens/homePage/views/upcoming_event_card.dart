import 'package:flutter/material.dart';
import '../../search_result/event/views/event_details_view.dart';
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
    return GestureDetector(
      onTap: () => _navigateToEventDetails(context),
      child: Container(
        height: isWeb ? 200.0 : 160.0,
        margin: const EdgeInsets.only(bottom: 16),
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
                topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  event.imageUrl,

                  fit: BoxFit.cover,
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
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title, 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isWeb ? 18 : 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        Text(
                          event.subtitle,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isWeb ? 14 : 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          event.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isWeb ? 14 : 12),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () => _navigateToEventDetails(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
                          minimumSize: Size(isWeb ? 120 : 90, isWeb ? 40 : 36),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        ),
                        child: Text(
                          "Join Event",
                          style: TextStyle(fontSize: isWeb ? 14 : 12),
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