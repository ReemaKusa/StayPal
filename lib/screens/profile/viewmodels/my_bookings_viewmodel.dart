import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/models/hotel_booking_model.dart';
import 'package:staypal/models/event_ticket_model.dart';

class MyBookingsViewModel extends ChangeNotifier {
  String selectedType = 'hotel';

  void setType(String type) {
    selectedType = type;
    notifyListeners();
  }

  Future<List<HotelBookingModel>> fetchHotelBookings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final snapshot =
        await FirebaseFirestore.instance
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
          await FirebaseFirestore.instance
              .collection('hotel')
              .doc(hotelId)
              .get();
      return doc.data()?['name'] ?? 'Unknown Hotel';
    } catch (_) {
      return 'Unknown Hotel';
    }
  }

  Future<List<EventTicketModel>> fetchEventTickets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final snapshot =
        await FirebaseFirestore.instance
            .collection('eventTickets')
            .where('userId', isEqualTo: user.uid)
            .orderBy('purchaseDate', descending: true)
            .get();

    return snapshot.docs
        .map((doc) => EventTicketModel.fromFirestore(doc))
        .toList();
  }

  Future<String> fetchEventName(String eventId) async {
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
