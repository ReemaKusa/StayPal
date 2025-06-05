import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/event_details_model.dart';

class EventDetailsViewModel with ChangeNotifier {
  final EventDetailsModel model;
  bool _isLiked;
  int _ticketCount = 1;
  bool _isBooking = false;
  int _ticketLimit = 0;
  int _ticketsSold = 0;

  EventDetailsViewModel({
    required this.model,
    bool isInitiallyLiked = false,
  }) : _isLiked = isInitiallyLiked {
    _ticketLimit = model.limite;
    _ticketsSold = model.ticketsSold;
  }

  bool get isLiked => _isLiked;
  int get ticketCount => _ticketCount;
  bool get isBooking => _isBooking;
  int get ticketLimit => _ticketLimit;
  int get ticketsSold => _ticketsSold;
  int get ticketsRemaining => _ticketLimit - _ticketsSold;
  bool get canAddMoreTickets => _ticketCount <= ticketsRemaining;
  bool get isSoldOut => ticketsRemaining <= 0;

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
    if (canAddMoreTickets) {
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
    if (isSoldOut) throw Exception('Event is sold out');
    if (_ticketCount > ticketsRemaining) {
      throw Exception('Not enough tickets available');
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    _isBooking = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(model.eventId)
          .update({
            'ticketsSold': FieldValue.increment(_ticketCount),
          });

      _ticketsSold += _ticketCount;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .add({
            'eventId': model.eventId,
            'ticketCount': _ticketCount,
            'bookingDate': DateTime.now(),
            'totalPrice': _ticketCount * model.price,
          });

    } catch (e) {
      debugPrint('Booking error: $e');
      rethrow;
    } finally {
      _isBooking = false;
      notifyListeners();
    }
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