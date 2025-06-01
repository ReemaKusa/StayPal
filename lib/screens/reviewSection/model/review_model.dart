import 'package:cloud_firestore/cloud_firestore.dart';


class Review {
  final String id;
  final String serviceId;
  final String userId;

  final String userName;
  final String? userPhoto;
  final double rating;

  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {

    final data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      serviceId: data['serviceId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',
      userPhoto: data['userPhoto'],
      rating: (data['rating'] as num).toDouble(),
      comment: data['comment'] ?? '',

      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'userId': userId,
      'userName': userName,
      'userPhoto': userPhoto,
      'rating': rating,
      'comment': comment,

      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}


class RatingStats {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;

  RatingStats({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    
  });
}