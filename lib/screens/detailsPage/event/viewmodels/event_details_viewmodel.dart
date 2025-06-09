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

  EventDetailsViewModel({
    required this.model,
    bool isInitiallyLiked = false,
  }) : _isLiked = isInitiallyLiked;

  bool get isLiked => _isLiked;
  int get ticketCount => _ticketCount;
  int get remainingTickets => model.availableTickets;
  bool get isBooking => _isBooking;
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
          .collection('event')
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
    if (_ticketCount < model.availableTickets) {
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
    if (_isBooking) return;
    _isBooking = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final hasCard = userDoc.data()?['hasCreditCard'] == true;

      if (!hasCard) {
        throw Exception('No credit card on file');
      }

      final ticketData = {
        'eventId': model.eventId,
        'eventName': model.name,
        'userId': user.uid,
        'purchaseDate': FieldValue.serverTimestamp(),
        'quantity': _ticketCount,
        'totalPrice': totalPrice,
      };


      await FirebaseFirestore.instance.collection('eventTickets').add(ticketData);


      await FirebaseFirestore.instance.collection('event').doc(model.eventId).update({
        'ticketsSold': FieldValue.increment(_ticketCount),
      });


      final updatedDoc = await FirebaseFirestore.instance.collection('event').doc(model.eventId).get();
      model.updateEvent(updatedDoc.data()!);

      notifyListeners();
    } catch (e) {
      debugPrint('Purchase error: $e');
      rethrow;
    } finally {
      _isBooking = false;
      notifyListeners();
    }
  }
  Future<void> reloadEventData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('event')
        .doc(model.eventId)
        .get();
    if (snapshot.exists) {
      model.updateEvent(snapshot.data()!);
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