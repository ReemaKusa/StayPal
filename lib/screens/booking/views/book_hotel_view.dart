import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:staypal/screens/booking/viewmodels/book_hotel_viewmodel.dart';
import 'package:staypal/constants/color_constants.dart';

class BookHotelView extends StatelessWidget {
  final String hotelId;
  final String hotelName;
  final double pricePerNight;

  const BookHotelView({
    super.key,
    required this.hotelId,
    required this.hotelName,
    required this.pricePerNight,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookHotelViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book Hotel'),
          centerTitle: true,
        ),
        body: _BookHotelForm(
          hotelId: hotelId,
          hotelName: hotelName,
          pricePerNight: pricePerNight,
        ),
      ),
    );
  }
}

class _BookHotelForm extends StatelessWidget {
  final String hotelId;
  final String hotelName;
  final double pricePerNight;

  const _BookHotelForm({
    super.key,
    required this.hotelId,
    required this.hotelName,
    required this.pricePerNight,
  });

  Widget _buildHotelInfoCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.hotel, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hotelName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price per night',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  '₪${pricePerNight.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectionCard(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEE, MMM d, y');

    return Consumer<BookHotelViewModel>(
      builder: (context, viewModel, child) {
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Check-in Date
                Row(
                  children: [
                    const Icon(Icons.login, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text('Check-in Date', style: theme.textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: viewModel.checkInDate!.add(const Duration(days: 1)),
                        firstDate: viewModel.checkInDate!.add(const Duration(days: 1)),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.primary,
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                ),
                              ),
                              dialogBackgroundColor: Colors.white,
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) viewModel.selectCheckInDate(picked);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: viewModel.checkInDate == null
                            ? Colors.grey
                            : AppColors.primary,
                      ),
                    ),
                    child: Text(
                      viewModel.checkInDate == null
                          ? 'Select Check-In Date'
                          : dateFormat.format(viewModel.checkInDate!),
                      style: TextStyle(
                        color: viewModel.checkInDate == null
                            ? Colors.grey[600]
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Check-out Date
                Row(
                  children: [
                    const Icon(Icons.logout, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text('Check-out Date', style: theme.textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: viewModel.checkInDate == null
                        ? null
                        : () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: viewModel.checkInDate!.add(const Duration(days: 1)),
                        firstDate: viewModel.checkInDate!.add(const Duration(days: 1)),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) viewModel.selectCheckOutDate(picked);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: viewModel.checkOutDate == null
                            ? Colors.grey
                            : AppColors.primary,
                      ),
                    ),
                    child: Text(
                      viewModel.checkOutDate == null
                          ? 'Select Check-Out Date'
                          : dateFormat.format(viewModel.checkOutDate!),
                      style: TextStyle(
                        color: viewModel.checkOutDate == null
                            ? Colors.grey[600]
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),

                // Stay Duration Info
                if (viewModel.getTotalNights() > 0) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Duration',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${viewModel.getTotalNights()} night${viewModel.getTotalNights() > 1 ? 's' : ''}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceSummaryCard(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<BookHotelViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.getTotalNights() <= 0) return const SizedBox.shrink();

        final totalPrice = viewModel.getTotalPrice(pricePerNight);

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price per night', style: theme.textTheme.bodyMedium),
                    Text('₪${pricePerNight.toStringAsFixed(2)}', style: theme.textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Number of nights', style: theme.textTheme.bodyMedium),
                    Text('${viewModel.getTotalNights()}', style: theme.textTheme.bodyMedium),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TOTAL', style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                    Text(
                      '₪${totalPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingButton(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<BookHotelViewModel>(
      builder: (context, viewModel, child) {
        final canBook = viewModel.getTotalNights() > 0 && !viewModel.isLoading;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canBook
                ? () async {
              final success = await viewModel.submitBooking(
                hotelId: hotelId,
                pricePerNight: pricePerNight,
              );

              if (!context.mounted) return;

              if (success) {
                _showSuccessModal(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.errorMessage ?? 'Booking failed'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: canBook ? AppColors.primary : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: viewModel.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
              canBook
                  ? 'Confirm Booking - ₪${viewModel.getTotalPrice(pricePerNight).toStringAsFixed(2)}'
                  : 'Select Dates to Continue',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 120,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Booking successfull!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Your hotel reservation has been done successfully confirmed.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Close modal
                Navigator.pop(context); // Go back to previous screen
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HOTEL DETAILS', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          _buildHotelInfoCard(context),

          const SizedBox(height: 20),
          Text('SELECT DATES', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          _buildDateSelectionCard(context),

          const SizedBox(height: 20),
          _buildPriceSummaryCard(context),

          const SizedBox(height: 20),
          _buildBookingButton(context),
        ],
      ),
    );
  }
}