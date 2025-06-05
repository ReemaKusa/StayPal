
import 'package:flutter/material.dart';

class EmptyReviewsWidget extends StatelessWidget {
  final bool isSearchResult;

  const EmptyReviewsWidget({
    Key? key,
    this.isSearchResult = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearchResult ? Icons.search_off : Icons.reviews,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isSearchResult ? 'No matching reviews' : 'No reviews yet',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              isSearchResult 
                  ? 'Try a different search term'
                  : 'Be the first to review this service!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}