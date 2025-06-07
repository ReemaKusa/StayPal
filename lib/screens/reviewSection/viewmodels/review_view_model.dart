import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/review_model.dart' as review_model;
import './feedback_state.dart';
import './rating_stats_manager.dart';
import './user_review_checker.dart';
import './review_manager.dart';
import './rating_stats.dart' as local_stats;

class FeedbackViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FeedbackState _state = FeedbackState();

  final RatingStatsManager _ratingStats = RatingStatsManager();
  final UserReviewChecker _userReviewChecker = UserReviewChecker();
  final ReviewManager _reviewManager = ReviewManager();

  double get userRating => _state.userRating;
  String get reviewText => _state.reviewText;
  bool get isSubmitting => _state.isSubmitting;

  String get searchQuery => _state.searchQuery;
  bool get hasUserReviewed => _userReviewChecker.hasUserReviewed;
  local_stats.RatingStats get ratingStats => _ratingStats.ratingStats;

  set userRating(double value) {
    _state.userRating = value;
    notifyListeners();
  }

  set reviewText(String value) {
    _state.reviewText = value;

  }

  set searchQuery(String value) {
    _state.searchQuery = value;
    notifyListeners();
  }

  void initialize(String serviceId, String serviceName) {
    _state.serviceId = serviceId;
    _state.serviceName = serviceName;
    _ratingStats.loadRatingStats(_state.serviceId!);
    _userReviewChecker.checkUserReview(_auth, _firestore, _state.serviceId!);
  }

  Future<void> submitReview() async {
    try {
      _validateReview();

      _state.isSubmitting = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final reviewData = await _reviewManager.prepareReviewData(
        _firestore,
        user,
        _state.serviceId!,
        _state.userRating,
        _state.reviewText,
      );

      await _firestore.collection('service_reviews').add(reviewData.toMap());

      _resetForm();
      await _ratingStats.loadRatingStats(_state.serviceId!);

      await _userReviewChecker.checkUserReview(_auth, _firestore, _state.serviceId!);
    } catch (e) {

      debugPrint('Review submission error: $e');
      rethrow;
    } finally {
      _state.isSubmitting = false;
      notifyListeners();
    }
  }

  void _validateReview() {
    if (_state.userRating == 0) throw Exception('Please select a rating');
    if (_state.reviewText.trim().isEmpty) throw Exception('Please write your review');

    if (_userReviewChecker.hasUserReviewed) throw Exception('You have already reviewed this service');
  }

  void _resetForm() {
    _state.reviewText = '';
    _state.userRating = 0;
  }

  Stream<List<review_model.Review>> getReviewsStream() {
    return _firestore
        .collection('service_reviews')
        .where('serviceId', isEqualTo: _state.serviceId)
        .orderBy('createdAt', descending: true)
        .snapshots()

        .map((snapshot) => snapshot.docs
            .map((doc) => review_model.Review.fromFirestore(doc))
            .toList());
  }

  List<review_model.Review> filterReviews(List<review_model.Review> reviews, String query) {
    return _reviewManager.filterReviews(reviews, query);

  }
}