import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/hotel_booking_model.dart';
import 'package:staypal/models/event_ticket_model.dart';
import 'package:staypal/screens/admin/services/hotel_booking_service.dart';
import 'package:staypal/screens/admin/services/event_ticket_service.dart';
import 'package:staypal/screens/admin/services/user_service.dart';
import 'package:staypal/constants/color_constants.dart';

class ListAllBookingsView extends StatefulWidget {
  const ListAllBookingsView({super.key});

  @override
  State<ListAllBookingsView> createState() => _ListAllBookingsViewState();
}

class _ListAllBookingsViewState extends State<ListAllBookingsView> {
  final HotelBookingService _hotelBookingService = HotelBookingService();
  final EventTicketService _eventTicketService = EventTicketService();
  final UserService _userService = UserService();

  late Future<List<Map<String, dynamic>>> _combinedBookingsFuture;
  String _selectedType = 'all';

  @override
  void initState() {
    super.initState();
    _combinedBookingsFuture = _loadCombinedBookings();
  }

  Future<String> fetchHotelName(String hotelId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('hotel').doc(hotelId).get();
      return doc.data()?['name'] ?? 'Unknown Hotel';
    } catch (_) {
      return 'Unknown Hotel';
    }
  }

  Future<String> fetchEventName(String eventId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('event').doc(eventId).get();
      return doc.data()?['name'] ?? 'Unknown Event';
    } catch (_) {
      return 'Unknown Event';
    }
  }

  Future<List<Map<String, dynamic>>> _loadCombinedBookings() async {
    final hotelBookings = await _hotelBookingService.fetchBookings();
    final eventTickets = await _eventTicketService.fetchTickets();


    final allBookings = [...hotelBookings, ...eventTickets];

    List<Map<String, dynamic>> enriched = [];
    for (final booking in allBookings) {
      String userId;
      String itemName;

      if (booking is HotelBookingModel) {
        userId = booking.userId;
        itemName = await fetchHotelName(booking.hotelId);
      } else if (booking is EventTicketModel) {
        userId = booking.userId;
        itemName = await fetchEventName(booking.eventId);
      } else {
        continue;
      }

      final user = await _userService.fetchUserById(userId);
      enriched.add({
        'booking': booking,
        'userName': user?.fullName ?? 'Unknown User',
        'itemName': itemName,
        'userEmail': user?.email ?? 'Unknown Email',

      });
    }

    return enriched;
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
              Expanded(child: _buildTypeButton('all', 'All')),
              const SizedBox(width: 12),
              Expanded(child: _buildTypeButton('event', 'Events')),
              const SizedBox(width: 12),
              Expanded(child: _buildTypeButton('hotel', 'Hotels')),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _combinedBookingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No bookings found.'));
                }

                final filtered = snapshot.data!.where((entry) {
                  final booking = entry['booking'];
                  if (_selectedType == 'event') return booking is EventTicketModel;
                  if (_selectedType == 'hotel') return booking is HotelBookingModel;
                  return true;
                }).toList();

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final entry = filtered[index];
                    final booking = entry['booking'];
                    final userName = entry['userName'];
                    final itemName = entry['itemName'];
                    final userEmail = entry['userEmail'];

                    if (booking is HotelBookingModel) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: const Icon(Icons.hotel, color: Colors.deepOrange),
                          title: Text(itemName),
                          subtitle: Text(
                              'User: $userName\nEmail: $userEmail\nCheck-in: ${booking.formattedCheckIn}\nCheck-out: ${booking.formattedCheckOut}\n₪${booking.price}',
                          ),
                          trailing: Chip(
                            label: Text(booking.status),
                            backgroundColor: _statusColor(booking.status),
                          ),
                        ),
                      );
                    } else if (booking is EventTicketModel) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.event, color: Colors.deepOrange),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text('User: $userName'),
                                    Text('Email: $userEmail'),
                                    Text('Tickets: ${booking.quantity}'),
                                    Text('₪${booking.totalPrice}'),
                                    Text(booking.formattedPurchaseDate),
                                    Text('Ref#: ${booking.bookingReference}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
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
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : AppColors.white,
          foregroundColor: isSelected ? AppColors.white : AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.primary.withOpacity(0.6)),
          ),
          elevation: isSelected ? 2 : 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () => setState(() => _selectedType = type),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
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