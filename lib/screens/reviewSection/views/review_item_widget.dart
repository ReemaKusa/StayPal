import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../model/review_model.dart';

class ReviewItemWidget extends StatelessWidget {
  final Review review;

  const ReviewItemWidget({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          const SizedBox(height: 12),
          _buildRating(),
          const SizedBox(height: 12),
          if (review.comment.isNotEmpty) _buildComment(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.deepOrange.shade100,
          backgroundImage: review.userPhoto != null && review.userPhoto!.isNotEmpty
              ? CachedNetworkImageProvider(review.userPhoto!)
              : null,
          child: review.userPhoto == null || review.userPhoto!.isEmpty
              ? Text(
                  review.userName[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.deepOrange.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                _formatTimestamp(review.createdAt),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRating() {
    return RatingBarIndicator(
      rating: review.rating,
      itemBuilder: (context, _) =>
          const Icon(Icons.star, color: Colors.deepOrange),
      itemCount: 5,
      itemSize: 20,
    );
  }

  Widget _buildComment() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        review.comment,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  String _formatTimestamp(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return 'Today at ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}