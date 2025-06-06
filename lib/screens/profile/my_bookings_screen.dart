import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/models/hotel_booking_model.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  String _selectedType = 'hotel';

  Future<List<HotelBookingModel>> fetchHotelBookings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final snapshot = await FirebaseFirestore.instance
        .collection('hotel_bookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => HotelBookingModel.fromFirestore(doc))
        .toList();
  }

  Future<String> fetchHotelName(String hotelId) async {
    try {
      final doc =
      await FirebaseFirestore.instance.collection('hotel').doc(hotelId).get();
      return doc.data()?['name'] ?? 'Unknown Hotel';
    } catch (_) {
      return 'Unknown Hotel';
    }
  }

  Future<void> _cancelBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('hotel_bookings')
          .doc(bookingId)
          .update({'status': 'cancelled'});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking cancelled')),
      );
      setState(() {}); // Refresh UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel: $e')),
      );
    }
  }

  void _showCancelConfirmation(String bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _cancelBooking(bookingId);
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.orange[700],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Hotels'),
                selected: _selectedType == 'hotel',
                onSelected: (_) => setState(() => _selectedType = 'hotel'),
                selectedColor: Colors.orange[700],
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text('Events'),
                selected: _selectedType == 'event',
                onSelected: (_) => setState(() => _selectedType = 'event'),
                selectedColor: Colors.orange[700],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedType == 'hotel') Expanded(child: _buildHotelBookingList()),
          if (_selectedType == 'event')
            const Expanded(
              child: Center(child: Text('Event bookings coming soon...')),
            ),
        ],
      ),
    );
  }

  Widget _buildHotelBookingList() {
    return FutureBuilder<List<HotelBookingModel>>(
      future: fetchHotelBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final bookings = snapshot.data ?? [];
        if (bookings.isEmpty) {
          return const Center(child: Text('No hotel bookings found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return FutureBuilder<String>(
              future: fetchHotelName(booking.hotelId),
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

  Widget _buildHotelCard(HotelBookingModel booking, String hotelName) {
    final nights = booking.checkOut.difference(booking.checkIn).inDays;
    final priceText = '${booking.price.toStringAsFixed(2)} ₪';
    final statusColor = booking.status == 'confirmed'
        ? Colors.green
        : booking.status == 'cancelled'
        ? Colors.red
        : Colors.orange;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hotelName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Check-In: ${booking.formattedCheckIn}',
                style: const TextStyle(fontSize: 16)),
            Text('Check-Out: ${booking.formattedCheckOut}',
                style: const TextStyle(fontSize: 16)),
            Text('$nights night${nights > 1 ? 's' : ''} stay'),
            const SizedBox(height: 8),
            Text('Total Price: $priceText',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Status: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Booked on: ${booking.formattedCreatedAt}',
                style: const TextStyle(color: Colors.black54)),
            if (booking.status == 'pending')
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () =>
                      _showCancelConfirmation(booking.bookingId),
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  label: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}