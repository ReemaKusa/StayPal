import 'package:cloud_firestore/cloud_firestore.dart';
import 'hotel_details_model.dart';

class HotelDetailsViewModel {
  final HotelDetailsModel _model;
  bool _isLiked;

  HotelDetailsViewModel(this._model) : _isLiked = _model.isInitiallyLiked;

  bool get isLiked => _isLiked;
  HotelDetailsModel get model => _model;

  void toggleLike() {
    _isLiked = !_isLiked;
  }

  Future<void> bookHotel() async {
    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'hotelId': _model.hotelId,
        'userId': 'currentUserId',
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
    } catch (e) {
      rethrow;
    }
  }

  String getShareMessage() {
    return '''
🏨 Check out this hotel: ${_model.name}
📍 Location: ${_model.location}
💸 Price: ${_model.price} ₪ per night
📄 Description: ${_model.description}

Book your stay now!
''';
  }
}