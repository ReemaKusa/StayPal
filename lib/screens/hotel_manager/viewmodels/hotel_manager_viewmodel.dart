import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/models/hotel_model.dart';

class HotelManagerViewModel extends ChangeNotifier {
  List<HotelModel> myHotels = [];
  bool isLoading = true;
  String? errorMessage;

  StreamSubscription<QuerySnapshot>? _hotelSubscription;

  void fetchHotelsForManager() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Cancel previous subscription if any
    _hotelSubscription?.cancel();

    _hotelSubscription = FirebaseFirestore.instance
        .collection('hotel')
        .where('managerId', isEqualTo: uid)
        .snapshots()
        .listen(
          (snapshot) {
        myHotels = snapshot.docs.map((doc) => HotelModel.fromDocument(doc)).toList();
        isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        errorMessage = 'Failed to load hotels: $error';
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void clearState() {
    myHotels = [];
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _hotelSubscription?.cancel();
    super.dispose();
  }
}