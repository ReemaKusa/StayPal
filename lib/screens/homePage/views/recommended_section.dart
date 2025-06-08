
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';
import 'recommended_card.dart';

class RecommendedSection extends StatelessWidget {
  final bool isWeb;

  const RecommendedSection({super.key, this.isWeb = false});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    if (isWeb) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recommended for You",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 3.5,
            ),
            itemCount: viewModel.recommendedItems.length,
            itemBuilder: (context, index) {
              final item = viewModel.recommendedItems[index];
              return RecommendedCard(
                title: item.title,
                subtitle: item.subtitle,
                imageUrl: item.imageUrl,
                id: item.id,
                isFavorite: item.isFavorite,
                type: item.type ?? 'event',
                isWeb: true,
              );
            },
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recommended for You",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Column(
          children: viewModel.recommendedItems.map((item) {
            return Column(
              children: [
                RecommendedCard(
                  title: item.title,
                  subtitle: item.subtitle,
                  imageUrl: item.imageUrl,
                  id: item.id,
                  isFavorite: item.isFavorite,
                  type: item.type ?? 'event',
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}