import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';
import 'recommended_card.dart';

class RecommendedSection extends StatelessWidget {

  final bool isWeb;

  const RecommendedSection({super.key, this.isWeb = false});

  static const sectionTitleStyleWeb = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const sectionTitleStyleMobile = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.recommendedItems.isEmpty) {
      return const Center(
        child: Text(
          'No recommendations available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

  
    final crossAxisCount = width > 1200 ? 2 : 1;
    final childAspectRatio = isWeb ? 3.5 : 2.5;

    if (isWeb) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recommended for You",
            style: sectionTitleStyleWeb,
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: viewModel.recommendedItems.length,
            itemBuilder: (context, index) {
              final item = viewModel.recommendedItems[index];
              return RecommendedCard(
                item: item,
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
          style: sectionTitleStyleMobile,
        ),
        const SizedBox(height: 12),
        ListView.separated(

          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: viewModel.recommendedItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = viewModel.recommendedItems[index];
            return RecommendedCard(
              item: item,
            );
          },
        ),
      ],
    );
  }
}