import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookHotelViewModel extends ChangeNotifier {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  bool isLoading = false;
  String? errorMessage;

  void selectCheckInDate(DateTime date) {
    checkInDate = date;
    checkOutDate = null;
    notifyListeners();
  }

  void selectCheckOutDate(DateTime date) {
    checkOutDate = date;
    notifyListeners();
  }

  int getTotalNights() {
    if (checkInDate != null && checkOutDate != null) {
      return checkOutDate!.difference(checkInDate!).inDays;
    }
    return 0;
  }

  double getTotalPrice(double pricePerNight) {
    return getTotalNights() * pricePerNight;
  }

  Future<bool> submitBooking({
    required String hotelId,
    required double pricePerNight,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      errorMessage = 'User not authenticated';
      return false;
    }

    if (checkInDate == null || checkOutDate == null) {
      errorMessage = 'Please select both check-in and check-out dates';
      return false;
    }

    if (!checkOutDate!.isAfter(checkInDate!)) {
      errorMessage = 'Check-out must be after check-in';
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('hotel_bookings').add({
        'userId': user.uid,
        'hotelId': hotelId,
        'checkIn': checkInDate!.toIso8601String(),
        'checkOut': checkOutDate!.toIso8601String(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'price': getTotalPrice(pricePerNight),
      });

      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = 'Booking failed: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}