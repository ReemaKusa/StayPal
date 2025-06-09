import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/booking_model.dart';

class BookingService {
  final bookingRef = FirebaseFirestore.instance.collection('bookings');

  Future<List<BookingModel>> fetchBookings() async {
    final snapshot = await bookingRef.orderBy('bookingDate', descending: true).get();
    return snapshot.docs.map((doc) => BookingModel.fromDoc(doc)).toList();
  }

  Future<int> fetchBookingCount() async {
    final snapshot = await bookingRef.get();
    return snapshot.docs.length;
  }
}