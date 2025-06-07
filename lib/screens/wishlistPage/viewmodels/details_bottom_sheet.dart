import 'package:flutter/material.dart';
import '../../view_details/hotel/views/hotel_details_view.dart';
import '../../view_details/event/views/event_details_view.dart';
import '../../wishlistPage/viewmodels/wishlist_view_model.dart';
import'./bottomSheetComponents/bottom_sheet_handel.dart';
import'./bottomSheetComponents/item_image.dart';
import'./bottomSheetComponents/item_subtitle.dart';
import'bottomSheetComponents/item_price.dart';
import'./bottomSheetComponents/item_title.dart';
import'./bottomSheetComponents/more_details_botton.dart';
import'./bottomSheetComponents/item_description.dart';


class DetailsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isHotel;
  final String id;
  final WishListViewModel viewModel;

  const DetailsBottomSheet({
    super.key,
    required this.item,
    required this.isHotel,
    required this.id,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = viewModel.getImageUrl(item['images']);
    final subtitle = viewModel.getSubtitle(item, isHotel);
    final description = item['description'] ?? 'No description available';
    final price = item['price']?.toString();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetHandle(),
            const SizedBox(height: 16),
            ItemTitle(name: item['name'] ?? 'No name'),
            const SizedBox(height: 8),
            ItemSubtitle(subtitle: subtitle),
            const SizedBox(height: 16),
            ItemImage(imageUrl: imageUrl),
            const SizedBox(height: 16),
            ItemDescription(description: description),
            if (price != null) ...[
              const SizedBox(height: 12),
              ItemPrice(price: price),
            ],
            const SizedBox(height: 24),
            MoreDetailsButton(
              onPressed: () => _navigateToDetails(context),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.pop(context);
    if (isHotel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HotelDetailsPage(
            hotel: item,
            hotelId: id,
            isInitiallyLiked: true,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EventDetailsPage(
            event: item,
            eventId: id,
            isInitiallyLiked: true,
          ),
        ),
      );
    }
  }
}