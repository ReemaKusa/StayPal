import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventBookingModel {
  final String bookingId;
  final String eventId;
  final String userId;
  final int ticketCount;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  EventBookingModel({
    required this.bookingId,
    required this.eventId,
    required this.userId,
    required this.ticketCount,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });


  factory EventBookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return EventBookingModel(
      bookingId: doc.id,
      eventId: data['eventId'] ?? '',
      userId: data['userId'] ?? '',
      ticketCount: data['ticketCount'] ?? 0,
      totalPrice: (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'userId': userId,
      'ticketCount': ticketCount,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String get formattedDate =>
      DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);

  String get formattedPrice => '${totalPrice.toStringAsFixed(2)} ₪';
}