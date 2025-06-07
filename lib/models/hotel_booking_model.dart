import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HotelBookingModel {
  final String bookingId;
  final String userId;
  final String hotelId;
  final DateTime checkIn;
  final DateTime checkOut;
  final double price; // ✅ Add this line
  final String status;
  final DateTime createdAt;

  HotelBookingModel({
    required this.bookingId,
    required this.userId,
    required this.hotelId,
    required this.checkIn,
    required this.checkOut,
    required this.price, // ✅ Include in constructor
    required this.status,
    required this.createdAt,
  });

  factory HotelBookingModel.fromMap(String id, Map<String, dynamic> data) {
    DateTime _convert(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.parse(value);
      return DateTime.now();
    }

    return HotelBookingModel(
      bookingId: id,
      userId: data['userId'] ?? '',
      hotelId: data['hotelId'] ?? '',
      checkIn: _convert(data['checkIn']),
      checkOut: _convert(data['checkOut']),
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? 'pending',
      createdAt: _convert(data['createdAt']),
    );
  }

  factory HotelBookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HotelBookingModel.fromMap(doc.id, data);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'hotelId': hotelId,
      'checkIn': Timestamp.fromDate(checkIn),
      'checkOut': Timestamp.fromDate(checkOut),
      'price': price,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String get formattedCheckIn =>
      DateFormat('yMMMd').format(checkIn);

  String get formattedCheckOut =>
      DateFormat('yMMMd').format(checkOut);

  String get formattedCreatedAt =>
      DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
}