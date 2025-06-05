import 'package:flutter/material.dart';
import 'package:staypal/screens/admin/models/booking_model.dart';
import 'package:staypal/screens/admin/services/booking_service.dart';
import 'package:intl/intl.dart';

class ListBookingsView extends StatefulWidget {
  const ListBookingsView({super.key});

  @override
  State<ListBookingsView> createState() => _ListBookingsViewState();
}

class _ListBookingsViewState extends State<ListBookingsView> {
  final BookingService _bookingService = BookingService();
  late Future<List<BookingModel>> _bookingsFuture;
  String _selectedType = 'all';

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _bookingService.fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('All Bookings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTypeButton('all', 'All'),
              const SizedBox(width: 12),
              _buildTypeButton('event', 'Events'),
              const SizedBox(width: 12),
              _buildTypeButton('hotel', 'Hotels'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<BookingModel>>(
              future: _bookingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No bookings found.'));
                }

                final bookings = snapshot.data!;
                final filtered = _selectedType == 'all'
                    ? bookings
                    : bookings.where((b) => b.eventId.startsWith(_selectedType)).toList();

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final booking = filtered[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.book_online),
                        title: Text(booking.eventName),
                        subtitle: Text(
                          'User: ${booking.userId}\nTickets: ${booking.tickets} | ₪${booking.totalPrice}\nDate: ${DateFormat.yMMMd().format(booking.bookingDate)}',
                        ),
                        trailing: Chip(
                          label: Text(booking.status),
                          backgroundColor: _statusColor(booking.status),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTypeButton(String type, String label) {
    final isSelected = _selectedType == type;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.deepPurple : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () => setState(() => _selectedType = type),
      child: Text(label),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      case 'pending':
      default:
        return Colors.orange.shade100;
    }
  }
}