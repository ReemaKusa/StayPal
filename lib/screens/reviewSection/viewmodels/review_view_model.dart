import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/review_model.dart';


class FeedbackViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _serviceId;
  String? _serviceName;
  double _userRating = 0;
  String _reviewText = '';
  bool _isSubmitting = false;
  String _searchQuery = '';

  bool _hasUserReviewed = false;


  RatingStats _ratingStats = RatingStats(
    averageRating: 0.0,
    totalReviews: 0,
    ratingDistribution: {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
  );


  double get userRating => _userRating;
  String get reviewText => _reviewText;
  bool get isSubmitting => _isSubmitting;
  String get searchQuery => _searchQuery;
  bool get hasUserReviewed => _hasUserReviewed;
  RatingStats get ratingStats => _ratingStats;



  set userRating(double value) {
    _userRating = value;
    notifyListeners();
  }

  set reviewText(String value) {
    _reviewText = value;
  }

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void initialize(String serviceId, String serviceName) {
    _serviceId = serviceId;
    _serviceName = serviceName;
    _loadRatingStats();
    _checkUserReview();
  }

  Future<void> _checkUserReview() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final query = await _firestore
          .collection('service_reviews')
          .where('serviceId', isEqualTo: _serviceId)
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      _hasUserReviewed = query.docs.isNotEmpty;
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking user review: $e');
    }
  }

  Future<void> _loadRatingStats() async {
    try {
      final reviewsSnapshot = await _firestore
          .collection('service_reviews')
          .where('serviceId', isEqualTo: _serviceId)
          .get();

      if (reviewsSnapshot.docs.isEmpty) return;


      final tempDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
      double totalRating = 0;

      for (final doc in reviewsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final rating = (data['rating'] as num).toInt();
        if (rating >= 1 && rating <= 5) {
          tempDistribution[rating] = tempDistribution[rating]! + 1;
          totalRating += rating;
        }
      }

      _ratingStats = RatingStats(
        averageRating: totalRating / reviewsSnapshot.docs.length,
        totalReviews: reviewsSnapshot.docs.length,
        ratingDistribution: tempDistribution,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading rating stats: $e');
    }
  }

  Future<void> submitReview() async {
    if (_userRating == 0) {
      throw Exception('Please select a rating');
    }

    if (_reviewText.trim().isEmpty) {
      throw Exception('Please write your review');
    }

    if (_hasUserReviewed) {
      throw Exception('You have already reviewed this service');
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');



      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;


      final reviewData = Review(
        id: '', 
        serviceId: _serviceId!,
        userId: user.uid,
        userName: userData['fullName'] ?? 'Anonymous',
        userPhoto: userData['photoUrl'],
        rating: _userRating,
        comment: _reviewText.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );



      await _firestore.collection('service_reviews').add(reviewData.toMap());


      _reviewText = '';
      _userRating = 0;
      await _loadRatingStats();
      await _checkUserReview();
    } catch (e) {
      debugPrint('Review submission error: $e');
      rethrow;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Stream<List<Review>> getReviewsStream() {
    return _firestore
        .collection('service_reviews')
        .where('serviceId', isEqualTo: _serviceId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Review.fromFirestore(doc))
            .toList());
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