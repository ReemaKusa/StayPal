import 'package:flutter/material.dart';
import 'package:staypal/screens/admin/services/hotel_service.dart';
import 'package:staypal/models/hotel_model.dart';
import 'edit_hotel_view.dart';

class ListHotelsView extends StatelessWidget {
  const ListHotelsView({super.key});

  @override
  Widget build(BuildContext context) {
    final hotelService = HotelService();

    return FutureBuilder<List<HotelModel>>(
      future: hotelService.fetchHotels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hotels found.'));
        }

        final hotels = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: hotels.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 360,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              final hotel = hotels[index];
              final imageUrl = hotel.images.isNotEmpty
                  ? hotel.images.first
                  : 'https://via.placeholder.com/300x200.png?text=No+Image';

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hotel.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                hotel.location,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(hotel.formattedPrice),
                              const SizedBox(height: 8),
                              Text(
                                hotel.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditHotelView(hotel: hotel),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
