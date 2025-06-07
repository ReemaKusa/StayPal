

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserReviewChecker {
  bool _hasUserReviewed = false;
  
  bool get hasUserReviewed => _hasUserReviewed;

  Future<void> checkUserReview(
    FirebaseAuth auth,
    FirebaseFirestore firestore,
    String serviceId,
  ) async {
    final user = auth.currentUser;
    if (user == null) return;

    try {
      final query = await firestore
          .collection('service_reviews')
          .where('serviceId', isEqualTo: serviceId)
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      _hasUserReviewed = query.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking user review: $e');
    }
  }
}