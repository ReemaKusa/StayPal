import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/hotel_model.dart';
import 'package:staypal/screens/admin/viewmodels/list_hotels_viewmodel.dart';
import 'edit_hotel_view.dart';

class ListHotelsView extends StatelessWidget {
  const ListHotelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListHotelsViewModel()..fetchHotels(),
      child: Consumer<ListHotelsViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.error != null) {
            return Center(child: Text('Error: ${viewModel.error}'));
          } else if (viewModel.hotels.isEmpty) {
            return const Center(child: Text('No hotels found.'));
          }

          final hotels = viewModel.hotels;

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = (constraints.maxWidth ~/ 300).clamp(1, 4);
              return Padding(
                padding: const EdgeInsets.all(AppPadding.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available Hotels',
                      style: TextStyle(
                        fontSize: AppFontSizes.title,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Expanded(
                      child: GridView.builder(
                        itemCount: hotels.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: AppSpacing.small,
                          mainAxisSpacing: AppSpacing.small,
                          childAspectRatio: 5 / 4,
                        ),
                        itemBuilder: (context, index) {
                          final hotel = hotels[index];
                          final imageUrl =
                              hotel.images.isNotEmpty
                                  ? hotel.images.first
                                  : 'https://via.placeholder.com/300x200.png?text=No+Image';

                          return Stack(
                            children: [
                              Card(
                                color: AppColors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppBorderRadius.card,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      imageUrl,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(
                                              height: AppSpacing.small,
                                            ),
                                            Text(
                                              hotel.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: AppFontSizes.subtitle,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.xSmall,
                                            ),
                                            Text(
                                              hotel.location,
                                              style: const TextStyle(
                                                fontSize: AppFontSizes.body,
                                                color: AppColors.grey,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.xSmall,
                                            ),
                                            Text(
                                              hotel.formattedPrice,
                                              style: const TextStyle(
                                                fontSize:
                                                    AppFontSizes.bottonfont,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.small,
                                            ),
                                            Text(
                                              hotel.description,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: AppFontSizes.body,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: AppSpacing.small,
                                right: AppSpacing.small,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => EditHotelView(hotel: hotel),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
