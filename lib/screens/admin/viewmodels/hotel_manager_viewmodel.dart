import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/screens/admin/models/hotel_model.dart';

class HotelManagerViewModel extends ChangeNotifier {
  List<HotelModel> myHotels = [];
  bool isLoading = true;

  Future<void> fetchHotelsForManager() async {
    try {
      isLoading = true;
      notifyListeners();

      final uid = FirebaseAuth.instance.currentUser!.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('hotel')
          .where('managerId', isEqualTo: uid)
          .get();

      myHotels = snapshot.docs.map((doc) => HotelModel.fromDocument(doc)).toList();
    } catch (e) {
      print('❌ Error fetching hotels: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}