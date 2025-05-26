import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'event_details_model.dart';

class EventDetailsViewModel with ChangeNotifier {
  final EventDetailsModel model;
  int _ticketCount = 1;
  bool _isLiked;

  EventDetailsViewModel({
    required this.model,
    bool isInitiallyLiked = false,
  }) : _isLiked = isInitiallyLiked;

  int get ticketCount => _ticketCount;
  bool get isLiked => _isLiked;
  double get totalPrice => model.price * _ticketCount;

  bool get isEventExpired {
    final eventDate = model.event['date'];
    DateTime? date;
    
    if (eventDate is Timestamp) {
      date = eventDate.toDate();
    } else if (eventDate is String) {
      date = DateTime.tryParse(eventDate);
    } else if (eventDate is DateTime) {
      date = eventDate;
    }
    
    return date != null && date.isBefore(DateTime.now());
  }

  void toggleLike() {
    _isLiked = !_isLiked;
    notifyListeners();
  }

  void increaseTicketCount() {
    _ticketCount++;
    notifyListeners();
  }

  void decreaseTicketCount() {
    if (_ticketCount > 1) {
      _ticketCount--;
      notifyListeners();
    }
  }

  String formatDate() {
    final eventDate = model.event['date'];
    if (eventDate is Timestamp) {
      return DateFormat('yyyy-MM-dd – HH:mm').format(eventDate.toDate());
    } else if (eventDate is String) {
      final parsedDate = DateTime.tryParse(eventDate);
      if (parsedDate != null) {
        return DateFormat('yyyy-MM-dd – HH:mm').format(parsedDate);
      }
      return eventDate;
    } else if (eventDate is DateTime) {
      return DateFormat('yyyy-MM-dd – HH:mm').format(eventDate);
    }
    return 'No date specified';
  }

  Future<void> bookEvent() async {
    try {
      final bookingData = {
        'eventId': model.eventId,
        'eventName': model.name,
        'tickets': _ticketCount,
        'totalPrice': totalPrice,
        'bookingDate': FieldValue.serverTimestamp(),
        'userId': 'current_user_id', // يجب استبدالها بمعرف المستخدم الفعلي
        'status': 'pending',
      };

      await FirebaseFirestore.instance.collection('bookings').add(bookingData);
      
    } on FirebaseException catch (e) {
      throw 'Booking failed: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  String getShareContent() {
    return '''
🎟️ Event: ${model.name}
📍 Location: ${model.location}
📅 Date: ${formatDate()}
💰 Price: ${model.price} ₪
⭐ Rating: ${model.rating}/5
''';
  }
}