import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  String _selectedType = 'hotel';

  Future<List<Map<String, dynamic>>> fetchBookings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final snapshot =
        await FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
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
                onSelected: (_) {
                  setState(() {
                    _selectedType = 'hotel';
                  });
                },
                selectedColor: Colors.orange[700],
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text('Events'),
                selected: _selectedType == 'event',
                onSelected: (_) {
                  setState(() {
                    _selectedType = 'event';
                  });
                },
                selectedColor: Colors.orange[700],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchBookings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final allBookings = snapshot.data ?? [];

                final filtered =
                    allBookings.where((booking) {
                      if (_selectedType == 'hotel') {
                        return booking.containsKey('hotelId');
                      } else {
                        return booking['type'] == 'event';
                      }
                    }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No bookings found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final booking = filtered[index];
                    return _selectedType == 'hotel'
                        ? _buildHotelCard(booking)
                        : _buildEventCard(booking);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> booking) {
    final hotelId = booking['hotelId'] ?? 'Unknown';
    final status = booking['status'] ?? 'N/A';
    final createdAt =
        booking['createdAt'] != null
            ? DateFormat(
              'yyyy-MM-dd – kk:mm',
            ).format((booking['createdAt'] as Timestamp).toDate())
            : 'Unknown date';

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
              'Hotel ID: $hotelId',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Status: $status'),
            const SizedBox(height: 4),
            Text('Booked on: $createdAt'),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> booking) {
    final eventName = booking['eventData']?['name'] ?? 'Event';
    final tickets = booking['tickets'] ?? 0;
    final date = booking['eventData']?['date'];
    final formattedDate =
        date is Timestamp
            ? DateFormat('yyyy-MM-dd').format(date.toDate())
            : 'No date';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(eventName),
        subtitle: Text('Tickets: $tickets\nDate: $formattedDate'),
        trailing: const Icon(Icons.event),
      ),
    );
  }
}
