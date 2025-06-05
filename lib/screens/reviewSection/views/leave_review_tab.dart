
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../viewmodels/review_view_model.dart';

class LeaveReviewTab extends StatelessWidget {
  final String serviceName;
  final Function() onReviewSubmitted;

  const LeaveReviewTab({
    Key? key,
    required this.serviceName,
    required this.onReviewSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedbackViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.hasUserReviewed) {
          return _buildAlreadyReviewed(context);
        }

        return _buildReviewForm(context, viewModel);
      },
    );
  }

  Widget _buildAlreadyReviewed(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const Text(
              'You have already reviewed this service',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you for your feedback!',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewForm(BuildContext context, FeedbackViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Share your experience',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'How would you rate $serviceName?',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          _buildRatingBar(viewModel),
          const SizedBox(height: 32),
          _buildCommentField(context, viewModel),
          const SizedBox(height: 32),
          _buildSubmitButton(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildRatingBar(FeedbackViewModel viewModel) {
    return Center(
      child: RatingBar.builder(
        initialRating: viewModel.userRating,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 6.0),
        itemBuilder: (context, _) =>
            const Icon(Icons.star, color: Colors.deepOrange, size: 40),
        onRatingUpdate: (rating) {
          viewModel.userRating = rating;
        },
      ),
    );
  }

  Widget _buildCommentField(BuildContext context, FeedbackViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tell us more',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'What did you like or dislike?',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            onChanged: (value) => viewModel.reviewText = value,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Write your detailed review here...',
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, FeedbackViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: viewModel.isSubmitting
            ? null
            : () async {
                try {
                  await viewModel.submitReview();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Thank you for your feedback!')),
                  );
                  onReviewSubmitted();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: viewModel.isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Submit Review',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}