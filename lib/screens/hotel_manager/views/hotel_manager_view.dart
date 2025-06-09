import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/hotel_manager/viewmodels/hotel_manager_viewmodel.dart';
import 'package:staypal/screens/admin/views/add_hotel_view.dart';
import 'package:staypal/screens/hotel_manager/views/my_bookings_manager_view.dart';
import 'package:staypal/screens/hotel_manager/views/my_ratings_manager_view.dart';
import 'package:staypal/widgets/add_button.dart';
import 'package:staypal/widgets/drawer.dart';
import 'package:staypal/widgets/hotel_card.dart';

class HotelManagerView extends StatelessWidget {
  const HotelManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HotelManagerViewModel()..fetchHotelsForManager(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        drawer: CustomRoleDrawer(
          roleTitle: 'Hotel Manager',
          optionTitle: 'My Hotels',
          optionIcon: Icons.hotel,
          onManageTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HotelManagerView()),
            );
          },
          onBookingsTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyBookingsManagerView()),
            );
          },
          onReviewsTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyRatingsManagerView()),
            );
          },
        ),
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Text(
            'Hotel Manager Panel',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        floatingActionButton: AddButton(
          targetView: const AddHotelView(assignToCurrentManager: true),
          onReturn: () {
            context.read<HotelManagerViewModel>().fetchHotelsForManager();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppPadding.screenPadding),
          child: Consumer<HotelManagerViewModel>(
            builder: (_, viewModel, __) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (viewModel.myHotels.isEmpty) {
                return const Center(
                  child: Text(
                    'No Hotels Assigned To You.',
                    style: TextStyle(
                      fontSize: AppFontSizes.subtitle,
                      color: AppColors.black,
                    ),
                  ),
                );
              }
              return ListView.separated(
                itemCount: viewModel.myHotels.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.cardVerticalMargin),
                itemBuilder: (_, index) => HotelCard(hotel: viewModel.myHotels[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}