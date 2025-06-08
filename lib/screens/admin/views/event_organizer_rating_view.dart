import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/widgets/drawer.dart';
import 'event_organizer_view.dart';
import 'event_organizer_bookings_view.dart';

class EventOrganizerRatingView extends StatefulWidget {
  const EventOrganizerRatingView({super.key});

  @override
  State<EventOrganizerRatingView> createState() => _EventOrganizerRatingViewState();
}

class _EventOrganizerRatingViewState extends State<EventOrganizerRatingView> {
  late Future<List<Map<String, dynamic>>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _fetchReviewsForMyEvents();
  }

  Future<List<Map<String, dynamic>>> _fetchReviewsForMyEvents() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final eventSnap = await FirebaseFirestore.instance
        .collection('event')
        .where('organizerId', isEqualTo: user.uid)
        .get();

    final eventIds = eventSnap.docs.map((e) => e.id).toList();
    if (eventIds.isEmpty) return [];

    final reviewSnap = await FirebaseFirestore.instance
        .collection('service_reviews')
        .where('serviceId', whereIn: eventIds)
        .get();

    final eventsMap = {
      for (var doc in eventSnap.docs) doc.id: doc.data()['name'] ?? 'Unnamed Event'
    };

    return reviewSnap.docs.map((doc) {
      final data = doc.data();
      return {
        'userName': data['userName'] ?? 'Anonymous',
        'comment': data['comment'] ?? '',
        'rating': data['rating'] ?? 0,
        'createdAt': (data['createdAt'] as Timestamp).toDate(),
        'eventName': eventsMap[data['serviceId']] ?? 'Unknown Event',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomRoleDrawer(
        roleTitle: 'Event Organizer',
        optionTitle: 'My Events',
        optionIcon: Icons.event,
        onManageTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const EventOrganizerView()),
          );
        },
        onBookingsTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const EventOrganizerBookingsView()),
          );
        },
        onReviewsTap: () {
          Navigator.pop(context); // Stays on current screen
        },
      ),
      appBar: AppBar(
        title: const Text('My Event Reviews', style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.primary),
        elevation: 0.5,
      ),
      backgroundColor: AppColors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final reviews = snapshot.data ?? [];
          if (reviews.isEmpty) {
            return const Center(child: Text("No one has reviewed your events yet."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppPadding.screenPadding),
            itemCount: reviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final r = reviews[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r['eventName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('⭐ ${r['rating']}  —  ${r['userName']}'),
                      const SizedBox(height: 4),
                      Text(DateFormat.yMMMd().add_jm().format(r['createdAt'])),
                      const Divider(),
                      Text(r['comment']),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}