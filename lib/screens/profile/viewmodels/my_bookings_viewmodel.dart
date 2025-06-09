import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/models/hotel_booking_model.dart';
import 'package:staypal/models/event_ticket_model.dart';

class MyBookingsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _selectedType = 'hotel';
  String get selectedType => _selectedType;

  void setSelectedType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  Future<List<HotelBookingModel>> fetchHotelBookings() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final snapshot = await _firestore
        .collection('hotel_bookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => HotelBookingModel.fromFirestore(doc)).toList();
  }

  Future<Map<String, dynamic>> fetchHotelDetails(String hotelId) async {
    try {
      final doc = await _firestore.collection('hotel').doc(hotelId).get();
      return doc.data() ?? {};
    } catch (_) {
      return {};
    }
  }

  Future<List<EventTicketModel>> fetchEventTickets() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final snapshot = await _firestore
        .collection('eventTickets')
        .where('userId', isEqualTo: user.uid)
        .orderBy('purchaseDate', descending: true)
        .get();

    return snapshot.docs.map((doc) => EventTicketModel.fromFirestore(doc)).toList();
  }

  Future<Map<String, dynamic>> fetchEventDetails(String eventId) async {
    try {
      final doc = await _firestore.collection('event').doc(eventId).get();
      return doc.data() ?? {};
    } catch (_) {
      return {};
    }
  }
}