import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/hotel_model.dart';

class HotelService {
  final hotelRef = FirebaseFirestore.instance.collection('hotel');

  Future<void> addHotel(Map<String, dynamic> hotelData) async {
    final snapshot = await hotelRef.get();

    final existingIds = snapshot.docs
        .map((doc) => int.tryParse(doc.id.replaceAll('hotel', '')))
        .whereType<int>()
        .toList();

    final nextId = existingIds.isEmpty ? 1 : (existingIds.reduce((a, b) => a > b ? a : b) + 1);
    final nextHotelId = 'hotel${nextId.toString().padLeft(2, '0')}';

    await hotelRef.doc(nextHotelId).set(hotelData);
  }

  Future<void> updateHotel(String id, Map<String, dynamic> hotelData) async {
    await hotelRef.doc(id).update(hotelData);
  }

  Future<void> deleteHotel(String id) async {
    await hotelRef.doc(id).delete();
  }

  Future<List<HotelModel>> fetchHotels() async {
    final snapshot = await hotelRef.get();

    return snapshot.docs
        .map((doc) {
      try {
        return HotelModel.fromDocument(doc);
      } catch (_) {
        return null;
      }
    })
        .whereType<HotelModel>()
        .toList();
  }


  Future<List<HotelModel>> fetchHotelsByManager(String managerId) async {
    final snapshot = await hotelRef.where('managerId', isEqualTo: managerId).get();

    return snapshot.docs
        .map((doc) {
      try {
        return HotelModel.fromDocument(doc);
      } catch (_) {
        return null;
      }
    })
        .whereType<HotelModel>()
        .toList();
  }
}