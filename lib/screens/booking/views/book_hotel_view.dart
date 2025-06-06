import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:staypal/screens/booking/viewmodels/book_hotel_viewmodel.dart';

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
          backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
          foregroundColor: Colors.white,
        ),
        body: const _BookHotelForm(),
      ),
    );
  }
}

class _BookHotelForm extends StatelessWidget {
  const _BookHotelForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BookHotelViewModel>(context);
    final hotelView = context.findAncestorWidgetOfExactType<BookHotelView>()!;
    final dateFormat = DateFormat('yMMMd');

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            hotelView.hotelName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Date Pickers
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) viewModel.selectCheckInDate(picked);
                  },
                  child: Text(viewModel.checkInDate == null
                      ? 'Select Check-In'
                      : 'Check-In:\n${dateFormat.format(viewModel.checkInDate!)}'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
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
                  child: Text(viewModel.checkOutDate == null
                      ? 'Select Check-Out'
                      : 'Check-Out:\n${dateFormat.format(viewModel.checkOutDate!)}'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Price Summary
          if (viewModel.getTotalNights() > 0) ...[
            Text('Total Nights: ${viewModel.getTotalNights()}'),
            Text('Price per Night: ${hotelView.pricePerNight.toStringAsFixed(2)} ₪'),
            Text('Total: ${viewModel.getTotalPrice(hotelView.pricePerNight).toStringAsFixed(2)} ₪'),
            const SizedBox(height: 16),
          ],

          // Submit Button
          ElevatedButton(
            onPressed: viewModel.isLoading
                ? null
                : () async {
              final success = await viewModel.submitBooking(
                hotelId: hotelView.hotelId,
                pricePerNight: hotelView.pricePerNight,
              );

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking successful')),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(viewModel.errorMessage ?? 'Booking failed')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: viewModel.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
              'Confirm Booking',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}