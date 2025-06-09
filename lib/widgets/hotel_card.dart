import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/hotel_model.dart';
import 'package:staypal/screens/admin/views/edit_hotel_view.dart';
import 'package:staypal/screens/hotel_manager/viewmodels/hotel_manager_viewmodel.dart';

class HotelCard extends StatelessWidget {
  final HotelModel hotel;
  const HotelCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.card),
      ),
      elevation: 1.5,
      child: Container(
        constraints: BoxConstraints(maxHeight: AppHeights.cardManagerHeight),
        margin: EdgeInsets.symmetric(vertical: AppMargin.verticalMargin),

        child: ListTile(
          leading: const Icon(
            Icons.apartment_rounded,
            color: AppColors.primary,
            size: AppSizes.iconSizeLarge,
          ),
          title: Text(
            hotel.name,
            style: const TextStyle(
              fontSize: AppFontSizes.subtitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${hotel.location} – ${hotel.formattedPrice}',
            style: const TextStyle(
              fontSize: AppFontSizes.body,
              color: Colors.black54,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: AppColors.black),
            onPressed: () {
              if (hotel.managerId == currentUid) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditHotelView(hotel: hotel),
                  ),
                ).then((_) {
                  context.read<HotelManagerViewModel>().fetchHotelsForManager();
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(' You are not allowed to edit this hotel.'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
