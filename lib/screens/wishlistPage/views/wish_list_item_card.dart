import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/constants/color_constants.dart';

import '../viewmodels/wishlist_view_model.dart';



class WishlistItemCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final WishListViewModel viewModel;

  const WishlistItemCard({
    super.key,
    required this.doc,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final item = doc.data() as Map<String, dynamic>;
    final isHotel = doc.reference.parent.id == 'hotel';

    return GestureDetector(
      onTap: () => viewModel.showDetailsBottomSheet(
        context,
        item,
        isHotel,
        doc.id,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildItemImage(),
            const SizedBox(width: 12),
            Expanded(child: _buildItemInfo()),
            _buildPopupMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage() {
    final item = doc.data() as Map<String, dynamic>;
    final imageUrl = viewModel.getImageUrl(item['images']);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      ),
      child: Image.network(
        imageUrl,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 100,
          width: 100,
          color: Colors.grey[200],
          child: const Icon(Icons.image, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildItemInfo() {
    final item = doc.data() as Map<String, dynamic>;
    final isHotel = doc.reference.parent.id == 'hotel';
    final subtitle = viewModel.getSubtitle(item, isHotel);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['name'] ?? 'No Name',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          if (item['price'] != null) _buildPriceText(),
        ],
      ),
    );
  }

  Widget _buildPriceText() {
    final item = doc.data() as Map<String, dynamic>;
    
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        '${item['price']?.toString() ?? 'N/A'} ₪',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    final item = doc.data() as Map<String, dynamic>;
    
    return PopupMenuButton<String>(
      onSelected: (value) {
        viewModel.handleMenuSelection(
          context,
          value,
          doc.reference,
          item['name'],
        );
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'remove',
          child: Text('Remove'),
        ),
        PopupMenuItem(
          value: 'share',
          child: Text('Share'),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.grey),
    );
  }
}