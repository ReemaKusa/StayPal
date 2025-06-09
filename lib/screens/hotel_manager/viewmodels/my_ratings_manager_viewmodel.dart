import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyRatingsManagerViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> get reviews => _reviews;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchReviews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final hotelSnap = await _firestore
          .collection('hotel')
          .where('managerId', isEqualTo: user.uid)
          .get();

      final hotelIds = hotelSnap.docs.map((doc) => doc.id).toList();
      if (hotelIds.isEmpty) {
        _reviews = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      final reviewSnap = await _firestore
          .collection('service_reviews')
          .where('serviceId', whereIn: hotelIds)
          .orderBy('createdAt', descending: true)
          .get();

      final hotelMap = {
        for (var doc in hotelSnap.docs)
          doc.id: doc.data()['name'] ?? 'Unnamed Hotel'
      };

      _reviews = reviewSnap.docs.map((doc) {
        final data = doc.data();
        return {
          'userName': data['userName'] ?? 'Anonymous',
          'comment': data['comment'] ?? '',
          'rating': data['rating'] ?? 0,
          'createdAt': (data['createdAt'] as Timestamp).toDate(),
          'hotelName': hotelMap[data['serviceId']] ?? 'Unknown Hotel',
        };
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}