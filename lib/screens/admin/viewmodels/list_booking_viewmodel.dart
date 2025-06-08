import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/hotel_booking_model.dart';
import 'package:staypal/models/event_ticket_model.dart';
import 'package:staypal/screens/admin/services/hotel_booking_service.dart';
import 'package:staypal/screens/admin/services/event_ticket_service.dart';
import 'package:staypal/screens/admin/services/user_service.dart';
import 'package:staypal/constants/color_constants.dart';

class ListAllBookingsViewModel extends ChangeNotifier {
  final HotelBookingService _hotelBookingService = HotelBookingService();
  final EventTicketService _eventTicketService = EventTicketService();
  final UserService _userService = UserService();

  late Future<List<Map<String, dynamic>>> combinedBookingsFuture;
  String selectedType = 'all';

  void loadCombinedBookings() {
    combinedBookingsFuture = _loadCombinedBookings();
    notifyListeners();
  }

  void setSelectedType(String type) {
    selectedType = type;
    notifyListeners();
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
        itemName = await _fetchHotelName(booking.hotelId);
      } else if (booking is EventTicketModel) {
        userId = booking.userId;
        itemName = await _fetchEventName(booking.eventId);
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

  List<Map<String, dynamic>> filterBookings(
    List<Map<String, dynamic>> allBookings,
  ) {
    return allBookings.where((entry) {
      final booking = entry['booking'];
      if (selectedType == 'event') return booking is EventTicketModel;
      if (selectedType == 'hotel') return booking is HotelBookingModel;
      return true;
    }).toList();
  }

  Widget buildBookingCard(Map<String, dynamic> entry) {
    final booking = entry['booking'];
    final userName = entry['userName'];
    final itemName = entry['itemName'];
    final userEmail = entry['userEmail'];

    if (booking is HotelBookingModel) {
      return Card(
        color: AppColors.white,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.greyTransparent)),
        child: ListTile(
          leading: const Icon(Icons.hotel, color: Colors.deepOrange),
          title: Text(itemName),
          subtitle: Text(
            'User: $userName\nEmail: $userEmail\nCheck-in: ${booking.formattedCheckIn}\nCheck-out: ${booking.formattedCheckOut}\n₪${booking.price}',
          ),
          trailing: Chip(
            label: Text(booking.status),
            backgroundColor: statusColor(booking.status),
          ),
        ),
      );
    } else if (booking is EventTicketModel) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    Text(
                      itemName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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
    }
    return const SizedBox.shrink();
  }

  Color statusColor(String status) {
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

  Future<String> _fetchHotelName(String hotelId) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('hotel')
              .doc(hotelId)
              .get();
      return doc.data()?['name'] ?? 'Unknown Hotel';
    } catch (_) {
      return 'Unknown Hotel';
    }
  }

  Future<String> _fetchEventName(String eventId) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('event')
              .doc(eventId)
              .get();
      return doc.data()?['name'] ?? 'Unknown Event';
    } catch (_) {
      return 'Unknown Event';
    }
  }
}
