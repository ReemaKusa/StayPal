import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/screens/admin/viewmodels/hotel_manager_viewmodel.dart';
import 'package:staypal/models/hotel_model.dart';
import 'package:staypal/screens/admin/views/edit_hotel_view.dart';

class HotelManagerView extends StatelessWidget {
  const HotelManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HotelManagerViewModel()..fetchHotelsForManager(),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Hotels')),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Navigate to AddHotelView if needed
          },
          child: const Icon(Icons.add),
        ),
        body: Consumer<HotelManagerViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.myHotels.isEmpty) {
              return const Center(child: Text('No hotels assigned to you.'));
            }

            return ListView.builder(
              itemCount: viewModel.myHotels.length,
              itemBuilder: (context, index) {
                final hotel = viewModel.myHotels[index];
                final currentUid = FirebaseAuth.instance.currentUser!.uid;
                final managerId = hotel.hotel['managerId'];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(hotel.name),
                    subtitle: Text('${hotel.location} - ${hotel.formattedPrice}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        if (managerId == currentUid) {
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
                              content: Text('🚫 You are not allowed to edit this hotel.'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}