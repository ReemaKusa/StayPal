import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class EventTicketModel {
  final String ticketId;
  final String userId;
  final String eventId;
  final DateTime purchaseDate;
  final int quantity;
  final double totalPrice;
  final String bookingReference;



  EventTicketModel({
    required this.ticketId,
    required this.userId,
    required this.eventId,
    required this.purchaseDate,
    required this.quantity,
    required this.totalPrice,
    required this.bookingReference,

  });

  factory EventTicketModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return EventTicketModel(
      ticketId: doc.id,
      userId: data['userId'] ?? '',
      eventId: data['eventId'] ?? '',
      purchaseDate: (data['purchaseDate'] as Timestamp).toDate(),
      quantity: data['quantity'] ?? 1,
      totalPrice: (data['totalPrice'] as num).toDouble(),
      bookingReference: data['bookingReference'] ?? 'UNKNOWN',

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'eventId': eventId,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'quantity': quantity,
      'totalPrice': totalPrice,
      'bookingReference': bookingReference,

    };
  }
  String get formattedPurchaseDate {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(purchaseDate);
  }
}