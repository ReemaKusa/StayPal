import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/screens/detailsPage/hotel/models/hotel_details_model.dart';

class HotelDetailsViewModel with ChangeNotifier {
  final HotelDetailsModel model;
  bool _isLiked;
  bool _isBooking = false;

  HotelDetailsViewModel({
    required this.model,
    bool isInitiallyLiked = false,
  }) : _isLiked = isInitiallyLiked;

  bool get isLiked => _isLiked;
  bool get isBooking => _isBooking;
  String get formattedPrice => model.formattedPrice;
  String get formattedRating => model.formattedRating;

  Future<void> toggleLike() async {
    try {
      final newValue = !_isLiked;
      _isLiked = newValue;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('hotel')
          .doc(model.hotelId)
          .update({'isFavorite': newValue});
    } on FirebaseException catch (e) {
      _isLiked = !_isLiked;
      notifyListeners();
      debugPrint('Error updating favorite status: ${e.message}');
      throw 'Failed to update favorite status';
    }
  }

  Future<void> bookHotel() async {
    if (_isBooking) return;
    _isBooking = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'hotelId': model.hotelId,
        'hotelName': model.name,
        'userId': 'current_user_id',
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
        'price': model.price,
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
🏨 ${model.name}
📍 ${model.location}
💰 ${formattedPrice} per night
⭐ ${formattedRating}
📄 ${model.description}

${model.details}
''';
  }
}
