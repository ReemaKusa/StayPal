
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'rating_stats.dart';

class RatingStatsManager {
  RatingStats _ratingStats = RatingStats(
    averageRating: 0.0,
    totalReviews: 0,
    ratingDistribution: {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
  );

  RatingStats get ratingStats => _ratingStats;

  Future<void> loadRatingStats(String serviceId) async {
    try {
      final reviewsSnapshot = await FirebaseFirestore.instance
          .collection('service_reviews')
          .where('serviceId', isEqualTo: serviceId)
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
    } catch (e) {
      debugPrint('Error loading rating stats: $e');
    }
  }
}