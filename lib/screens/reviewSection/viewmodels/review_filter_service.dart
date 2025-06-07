

import '../model/review_model.dart';

class ReviewFilterService {
  static List<Review> filterReviews(List<Review> reviews, String query) {
    return reviews.where((review) {
      final comment = review.comment.toLowerCase();
      final userName = review.userName.toLowerCase();
      return comment.contains(query.toLowerCase()) ||
          userName.contains(query.toLowerCase());
    }).toList();
  }
}