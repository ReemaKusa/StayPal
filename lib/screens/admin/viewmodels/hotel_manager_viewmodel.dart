import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/models/hotel_model.dart';

class HotelManagerViewModel extends ChangeNotifier {
  List<HotelModel> myHotels = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> fetchHotelsForManager() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final uid = FirebaseAuth.instance.currentUser!.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('hotel')
          .where('managerId', isEqualTo: uid)
          .get();

      myHotels = snapshot.docs.map((doc) => HotelModel.fromDocument(doc)).toList();
    } catch (e) {
      errorMessage = 'Failed to load hotels: $e';
      print('❌ Error fetching hotels: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshHotels() async {
    await fetchHotelsForManager();
  }

  void clearState() {
    myHotels = [];
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }
}