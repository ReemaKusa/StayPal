import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/admin/viewmodels/my_ratings_manager_viewmodel.dart';
import 'package:staypal/screens/admin/views/hotel_manager_view.dart';
import 'package:staypal/screens/admin/views/my_bookings_manager_view.dart';
import 'package:staypal/widgets/drawer.dart';


class MyRatingsManagerView extends StatelessWidget {
  const MyRatingsManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyRatingsManagerViewModel()..fetchReviews(),
      child: Consumer<MyRatingsManagerViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyBookingsManagerView()),
                );
              },
              onReviewsTap: () {
                Navigator.pop(context);
              },
            ),
            appBar: AppBar(
              title: const Text('My Hotel Reviews', style: TextStyle(color: AppColors.black)),
              backgroundColor: AppColors.white,
              iconTheme: const IconThemeData(color: AppColors.primary),
              elevation: 0.5,
            ),
            backgroundColor: AppColors.white,
            body: Builder(
              builder: (context) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (viewModel.error != null) {
                  return Center(child: Text("Error: ${viewModel.error}"));
                }
                if (viewModel.reviews.isEmpty) {
                  return const Center(child: Text("No one has reviewed your hotels yet."));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppPadding.screenPadding),
                  itemCount: viewModel.reviews.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final r = viewModel.reviews[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(AppPadding.cardPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r['hotelName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(' ${r['rating']}  —  ${r['userName']}'),
                            const SizedBox(height: 4),
                            Text(DateFormat.yMMMd().add_jm().format(r['createdAt'])),
                            const Divider(),
                            Text(r['comment']),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
