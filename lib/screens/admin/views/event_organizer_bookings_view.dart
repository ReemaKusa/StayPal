import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/event_ticket_model.dart';
import 'package:staypal/screens/admin/viewmodels/event_organizer_bookings_viewmodel.dart';
import 'package:staypal/widgets/drawer.dart';
import 'event_organizer_view.dart';
import 'event_organizer_rating_view.dart';

class EventOrganizerBookingsView extends StatelessWidget {
  const EventOrganizerBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventOrganizerBookingsViewModel(),
      child: const _EventOrganizerBookingsBody(),
    );
  }
}

class _EventOrganizerBookingsBody extends StatelessWidget {
  const _EventOrganizerBookingsBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EventOrganizerBookingsViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.white,
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
        future: viewModel.fetchTicketsByOrganizer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tickets = snapshot.data ?? [];
          if (tickets.isEmpty) {
            return const Center(child: Text('No one has purchased tickets for your events yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppPadding.screenPadding),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return FutureBuilder(
                future: Future.wait([
                  viewModel.fetchEventName(ticket.eventId),
                  viewModel.fetchUserData(ticket.userId),
                ]),
                builder: (context, snap) {
                  if (!snap.hasData) return const SizedBox();

                  final eventName = snap.data?[0] as String;
                  final user = snap.data?[1] as Map<String, dynamic>;
                  final userName = user['fullName'] ?? 'Unknown';
                  final userEmail = user['email'] ?? 'unknown@email.com';

                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.cardVerticalMargin),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.card),
                    ),
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