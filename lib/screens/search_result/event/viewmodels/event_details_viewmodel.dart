import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <== تم إضافته
import 'package:intl/intl.dart';
import '../models/event_details_model.dart';

class EventDetailsViewModel with ChangeNotifier {
  final EventDetailsModel model;
  bool _isLiked;
  int _ticketCount = 1;
  bool _isBooking = false;
  int? _ticketLimit;
  int? _ticketsSold;

  EventDetailsViewModel({
    required this.model,
    bool isInitiallyLiked = false,
  }) : _isLiked = isInitiallyLiked;

  bool get isLiked => _isLiked;
  int get ticketCount => _ticketCount;
  bool get isBooking => _isBooking;
  int? get ticketLimit => _ticketLimit;
  int? get ticketsRemaining => _ticketLimit != null ? _ticketLimit! - (_ticketsSold ?? 0) : null;
  bool get canAddMoreTickets => ticketsRemaining == null || _ticketCount < ticketsRemaining!;

  set isBooking(bool value) {
    _isBooking = value;
    notifyListeners();
  }

  double get totalPrice => (_ticketCount * model.price).clamp(0, double.maxFinite);
  String get formattedTotalPrice => '${totalPrice.toStringAsFixed(2)} ₪';

  bool get isEventExpired {
    final eventDate = model.date?.toDate();
    return eventDate != null && eventDate.isBefore(DateTime.now());
  }

  Future<void> loadTicketLimit() async {
    try {
      final eventDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(model.eventId)
          .get();

      if (eventDoc.exists) {
        _ticketLimit = eventDoc.data()?['limite'] as int?;
        _ticketsSold = eventDoc.data()?['ticketsSold'] as int? ?? 0;
      }
    } catch (e) {
      throw Exception('Failed to load ticket limit: $e');
    }
  }

  String formatDate() {
    if (model.date != null) {
      return DateFormat('EEE, MMM d, y').format(model.date!.toDate());
    }
    return 'Date not specified';
  }

  Future<void> toggleLike() async {
    try {
      final newValue = !_isLiked;
      _isLiked = newValue;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('events')
          .doc(model.eventId)
          .update({'isFavorite': newValue});
    } on FirebaseException catch (e) {
      _isLiked = !_isLiked;
      notifyListeners();
      debugPrint('Error updating favorite status: ${e.message}');
      throw 'Failed to update favorite status';
    }
  }

  void increaseTicketCount() {
    if (_ticketCount < 20 && canAddMoreTickets) {
      _ticketCount++;
      notifyListeners();
    }
  }

  void decreaseTicketCount() {
    if (_ticketCount > 1) {
      _ticketCount--;
      notifyListeners();
    }
  }

  Future<void> bookEvent() async {
    if (ticketsRemaining != null && _ticketCount > ticketsRemaining!) {
      throw Exception('Not enough tickets available');
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final batch = FirebaseFirestore.instance.batch();
    final eventRef = FirebaseFirestore.instance.collection('events').doc(model.eventId);

    batch.update(eventRef, {
      'ticketsSold': FieldValue.increment(_ticketCount),
    });

    final userBookingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('bookings')
        .doc();

    batch.set(userBookingRef, {
      'eventId': model.eventId,
      'ticketCount': _ticketCount,
      'bookingDate': DateTime.now(),
      'totalPrice': _ticketCount * model.price,
    });

    await batch.commit();
    _ticketsSold = (_ticketsSold ?? 0) + _ticketCount;
    notifyListeners();
  }

  String getShareContent() {
    return '''
🎟️ ${model.name}
📍 ${model.location}
📅 ${formatDate()} at ${model.formattedTime}
💰 ${model.formattedPrice}
${model.description}

${model.details}
''';
  }
}
