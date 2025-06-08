import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/models/hotel_booking_model.dart';
import 'package:staypal/models/event_ticket_model.dart';
import 'package:staypal/screens/profile/viewmodels/my_bookings_viewmodel.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyBookingsViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Bookings'),
          backgroundColor: Colors.orange[700],
        ),
        body: Consumer<MyBookingsViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('Hotels'),
                      selected: viewModel.selectedType == 'hotel',
                      onSelected: (_) => viewModel.setType('hotel'),
                      selectedColor: Colors.orange[700],
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('Events'),
                      selected: viewModel.selectedType == 'event',
                      onSelected: (_) => viewModel.setType('event'),
                      selectedColor: Colors.orange[700],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (viewModel.selectedType == 'hotel')
                  Expanded(child: _buildHotelList(viewModel)),
                if (viewModel.selectedType == 'event')
                  Expanded(child: _buildEventList(viewModel)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHotelList(MyBookingsViewModel viewModel) {
    return FutureBuilder<List<HotelBookingModel>>(
      future: viewModel.fetchHotelBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        final bookings = snapshot.data ?? [];
        if (bookings.isEmpty)
          return const Center(child: Text('No hotel bookings found.'));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return FutureBuilder<String>(
              future: viewModel.fetchHotelName(booking.hotelId),
              builder: (context, nameSnap) {
                final hotelName = nameSnap.data ?? '...';
                return _buildHotelCard(booking, hotelName);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEventList(MyBookingsViewModel viewModel) {
    return FutureBuilder<List<EventTicketModel>>(
      future: viewModel.fetchEventTickets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        final tickets = snapshot.data ?? [];
        if (tickets.isEmpty)
          return const Center(child: Text('No event tickets found.'));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticket = tickets[index];
            return FutureBuilder<String>(
              future: viewModel.fetchEventName(ticket.eventId),
              builder: (context, nameSnap) {
                final eventName = nameSnap.data ?? '...';
                return _buildEventCard(ticket, eventName);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildHotelCard(HotelBookingModel booking, String hotelName) {
    final nights = booking.checkOut.difference(booking.checkIn).inDays;
    final priceText = '${booking.price.toStringAsFixed(2)} ₪';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hotelName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Check-In: ${booking.formattedCheckIn}'),
            Text('Check-Out: ${booking.formattedCheckOut}'),
            Text('$nights night${nights > 1 ? 's' : ''} stay'),
            const SizedBox(height: 8),
            Text('Total Price: $priceText'),
            const SizedBox(height: 8),
            Text('Status: ${booking.status}'),
            Text('Booked on: ${booking.formattedCreatedAt}'),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(EventTicketModel ticket, String eventName) {
    final priceText = '${ticket.totalPrice.toStringAsFixed(2)} ₪';
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Quantity: ${ticket.quantity}'),
            Text('Total Paid: $priceText'),
            Text('Purchased on: ${ticket.formattedPurchaseDate}'),
            Text('Reference: ${ticket.bookingReference}'),
          ],
        ),
      ),
    );
  }
}
