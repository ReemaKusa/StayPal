import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/models/event_ticket_model.dart';

class EventOrganizerBookingsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<EventTicketModel>> fetchTicketsByOrganizer() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final eventsSnap = await _firestore
        .collection('event')
        .where('organizerId', isEqualTo: user.uid)
        .get();

    final eventIds = eventsSnap.docs.map((e) => e.id).toList();
    if (eventIds.isEmpty) return [];

    final ticketsSnap = await _firestore
        .collection('eventTickets')
        .where('eventId', whereIn: eventIds)
        .orderBy('purchaseDate', descending: true)
        .get();

    return ticketsSnap.docs.map((doc) => EventTicketModel.fromFirestore(doc)).toList();
  }

  Future<String> fetchEventName(String eventId) async {
    try {
      final doc = await _firestore.collection('event').doc(eventId).get();
      return doc.data()?['name'] ?? 'Unknown Event';
    } catch (_) {
      return 'Unknown Event';
    }
  }

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data() ?? {};
    } catch (_) {
      return {};
    }
  }
}
