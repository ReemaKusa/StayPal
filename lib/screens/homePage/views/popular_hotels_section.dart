import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';
import './popular_hotel_card.dart';

class PopularHotelsSection extends StatelessWidget {
  final bool isWeb;


  const PopularHotelsSection({super.key, this.isWeb = false});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200 ? 4 : width > 900 ? 3 : 2;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }



    if (viewModel.popularHotels.isEmpty) {
      return const Center(
        child: Text(
          'No popular hotels available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (isWeb) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popular Hotels",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.8,
            ),
            itemCount: viewModel.popularHotels.length,
            itemBuilder: (context, index) {
              final hotel = viewModel.popularHotels[index];
              return HotelCard(
                hotel: hotel,
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
          "Hotels Popular Now",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemCount: viewModel.popularHotels.length,
            itemBuilder: (context, index) {
              final hotel = viewModel.popularHotels[index];
              return HotelCard(
                hotel: hotel,
              );
            },
          ),
        ),
      ],
    );
  }
}