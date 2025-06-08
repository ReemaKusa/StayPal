import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/event_ticket_model.dart';
import 'package:staypal/widgets/drawer.dart';
import 'event_organizer_view.dart';
import 'event_organizer_rating_view.dart';

class EventOrganizerBookingsView extends StatefulWidget {
  const EventOrganizerBookingsView({super.key});

  @override
  State<EventOrganizerBookingsView> createState() => _EventOrganizerBookingsViewState();
}

class _EventOrganizerBookingsViewState extends State<EventOrganizerBookingsView> {
  Future<List<EventTicketModel>> fetchTicketsByOrganizer() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final eventsSnap = await FirebaseFirestore.instance
        .collection('event')
        .where('organizerId', isEqualTo: user.uid)
        .get();

    final eventIds = eventsSnap.docs.map((e) => e.id).toList();
    if (eventIds.isEmpty) return [];

    final ticketsSnap = await FirebaseFirestore.instance
        .collection('eventTickets')
        .where('eventId', whereIn: eventIds)
        .orderBy('purchaseDate', descending: true)
        .get();

    return ticketsSnap.docs.map((doc) => EventTicketModel.fromFirestore(doc)).toList();
  }

  Future<String> fetchEventName(String eventId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('event').doc(eventId).get();
      return doc.data()?['name'] ?? 'Unknown Event';
    } catch (_) {
      return 'Unknown Event';
    }
  }

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return doc.data() ?? {};
    } catch (_) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: CustomRoleDrawer(
        roleTitle: 'Event Organizer',
        optionTitle: 'My Events',
        optionIcon: Icons.event,
        onManageTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EventOrganizerView()));
        },
        onBookingsTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EventOrganizerBookingsView()));
        },
        onReviewsTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const EventOrganizerRatingView()),
          );
        },
      ),
      appBar: AppBar(
        title: const Text('My Event Bookings', style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.primary),
        elevation: 0.5,
      ),
      body: FutureBuilder<List<EventTicketModel>>(
        future: fetchTicketsByOrganizer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final tickets = snapshot.data ?? [];
          if (tickets.isEmpty) return const Center(child: Text('No one has purchased tickets for your events yet'));

          return ListView.builder(
            padding: const EdgeInsets.all(AppPadding.screenPadding),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return FutureBuilder(
                future: Future.wait([
                  fetchEventName(ticket.eventId),
                  fetchUserData(ticket.userId),
                ]),
                builder: (context, snap) {
                  if (!snap.hasData) return const SizedBox();

                  final eventName = snap.data?[0] as String;
                  final user = snap.data?[1] as Map<String, dynamic>;
                  final userName = user['fullName'] ?? 'Unknown';
                  final userEmail = user['email'] ?? 'unknown@email.com';

                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.cardVerticalMargin),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.card)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.cardPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(eventName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('👤 $userName'),
                          Text('📧 $userEmail'),
                          const Divider(),
                          Text('Tickets: ${ticket.quantity}'),
                          Text('Total: ${ticket.totalPrice.toStringAsFixed(2)} ₪'),
                          Text('Purchased: ${ticket.formattedPurchaseDate}'),
                          Text('Ref#: ${ticket.bookingReference}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}