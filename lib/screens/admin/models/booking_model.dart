import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String bookingId;
  final String userId;
  final String eventId;
  final String eventName;
  final String bookingType; // 'event' or 'hotel'
  final String status;
  final double totalPrice;
  final DateTime bookingDate;

  // Optional fields based on bookingType
  final int? tickets; // only for events
  final int? roomCount; 
  final DateTime? checkInDate;
  final DateTime? checkOutDate;

  BookingModel({
    required this.bookingId,
    required this.userId,
    required this.eventId,
    required this.eventName,
    required this.bookingType,
    required this.status,
    required this.totalPrice,
    required this.bookingDate,
    this.tickets,
    this.roomCount,
    this.checkInDate,
    this.checkOutDate,
  });

  factory BookingModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return BookingModel(
      bookingId: doc.id,
      userId: data['userId'] ?? '',
      eventId: data['eventId'] ?? '',
      eventName: data['eventName'] ?? 'Unknown',
      bookingType: data['bookingType'] ?? 'event',
      status: data['status'] ?? 'pending',
      totalPrice: (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      tickets: data['tickets'],
      roomCount: data['roomCount'],
      checkInDate: data['checkInDate'] != null
          ? (data['checkInDate'] as Timestamp).toDate()
          : null,
      checkOutDate: data['checkOutDate'] != null
          ? (data['checkOutDate'] as Timestamp).toDate()
          : null,
    );
  }
}