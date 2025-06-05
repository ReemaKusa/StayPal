

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/review_model.dart';

class ReviewManager {
  Future<Review> prepareReviewData(
    FirebaseFirestore firestore,
    User user,
    String serviceId,
    double userRating,
    String reviewText,
  ) async {
    final userDoc = await firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) throw Exception('User document not found');

    final userData = userDoc.data() as Map<String, dynamic>;

    return Review(
      id: '',
      serviceId: serviceId,
      userId: user.uid,
      userName: userData['fullName'] ?? 'Anonymous',
      userPhoto: userData['photoUrl'],
      rating: userRating,
      comment: reviewText.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  List<Review> filterReviews(List<Review> reviews, String query) {
    return reviews.where((review) {
      final comment = review.comment.toLowerCase();
      final userName = review.userName.toLowerCase();
      return comment.contains(query.toLowerCase()) ||
          userName.contains(query.toLowerCase());
    }).toList();
  }
}