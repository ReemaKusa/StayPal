import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/hotel_booking_model.dart';

class HotelBookingService {
  Future<List<HotelBookingModel>> fetchBookings() async {
    final snapshot = await FirebaseFirestore.instance.collection('hotel_bookings').get();
    return snapshot.docs.map((doc) => HotelBookingModel.fromFirestore(doc)).toList();
  }

  Future<String> getHotelNameById(String hotelId) async {
    final doc = await FirebaseFirestore.instance.collection('hotels').doc(hotelId).get();
    if (doc.exists) {
      return doc['name'] ?? 'Unnamed Hotel';
    }
    return 'Unknown Hotel';
  }
}