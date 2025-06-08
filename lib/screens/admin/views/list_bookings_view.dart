import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/admin/viewmodels/list_booking_viewmodel.dart';

class ListAllBookingsView extends StatelessWidget {
  const ListAllBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListAllBookingsViewModel()..loadCombinedBookings(),
      child: const _ListAllBookingsBody(),
    );
  }
}

class _ListAllBookingsBody extends StatelessWidget {
  const _ListAllBookingsBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ListAllBookingsViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Bookings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTypeButton(context, viewModel, 'all', 'All'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeButton(context, viewModel, 'event', 'Events'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeButton(context, viewModel, 'hotel', 'Hotels'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: viewModel.combinedBookingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: \${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No bookings found.'));
                }

                final filtered = viewModel.filterBookings(snapshot.data!);

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return viewModel.buildBookingCard(filtered[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(
    BuildContext context,
    ListAllBookingsViewModel viewModel,
    String type,
    String label,
  ) {
    final isSelected = viewModel.selectedType == type;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : AppColors.white,
          foregroundColor: isSelected ? AppColors.white : AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.primary.withOpacity(0.6)),
          ),
          elevation: isSelected ? 2 : 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () => viewModel.setSelectedType(type),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
