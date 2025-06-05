import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/screens/admin/viewmodels/hotel_manager_viewmodel.dart';
import 'package:staypal/models/hotel_model.dart';
import 'package:staypal/screens/admin/views/edit_hotel_view.dart';
import 'package:staypal/screens/admin/views/add_hotel_view.dart';
import 'package:staypal/screens/auth/viewmodels/logout_viewmodel.dart';

class HotelManagerView extends StatelessWidget {
  const HotelManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HotelManagerViewModel()..fetchHotelsForManager(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Hotel Manager Panel')),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.deepPurple),
                child: Text(
                  'Hotel Manager',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.hotel),
                title: const Text('My Hotels'),
                onTap: () {
                  Navigator.pop(context); // close drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context); // close drawer
                  LogoutViewModel().logout(context);
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddHotelView(assignToCurrentManager: true),
              ),
            );
            // Ensure refresh after return
            if (context.mounted) {
              context.read<HotelManagerViewModel>().fetchHotelsForManager();
            }
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
                final managerId = hotel.managerId;

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
                            MaterialPageRoute(builder: (_) => EditHotelView(hotel: hotel)),
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