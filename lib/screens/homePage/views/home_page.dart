import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';
import '../models/popular_hotels_model.dart';
import '../models/recommended_item_model.dart';
import '../models/upcoming_events_model.dart';
// import '../../search_result/hotel/views/hotel_details_view.dart';
// import '../../search_result/event/event_details_view.dart';
import '../../search_result/hotel/views/hotel_details_view.dart';
import '../../search_result/event/views/event_details_view.dart';
import '../widgets/custom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final GlobalKey searchKey = GlobalKey();

  void _scrollToSearch(BuildContext context) {
    if (searchKey.currentContext != null) {
      Scrollable.ensureVisible(
        searchKey.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _performSearch(BuildContext context) {
    void _performSearch(BuildContext context) {
      final viewModel = Provider.of<HomeViewModel>(context, listen: false);
      final query = viewModel.searchQuery.trim();
      if (query.isEmpty) return;

      final isNumeric = double.tryParse(query) != null;
      final filterBy = isNumeric ? 'price' : 'location';

      // CRITICAL CHANGE: Ensure numeric values stay as doubles
      dynamic searchValue;
      if (isNumeric) {
        searchValue = double.parse(query);
      } else {
        searchValue = query;
      }

      Navigator.pushNamed(
        context,
        '/searchresult',
        arguments: {
          'searchQuery': searchValue,
          'filterBy': filterBy,
          'isNumeric': isNumeric, // Explicit type flag
        },
      );
      viewModel.clearSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel()..fetchData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return CustomNavBar(
              currentIndex: 0,
              searchKey: searchKey,
              onSearchPressed: () => _scrollToSearch(context),
            );
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  controller: viewModel.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 16),
                      _buildSearchField(context),
                      if (viewModel.searchQuery.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _buildSearchButton(context),
                      ],
                      const SizedBox(height: 24),
                      _buildUpcomingEvents(context),
                      const SizedBox(height: 28),
                      _buildPopularHotels(context),
                      const SizedBox(height: 30),
                      _buildRecommendedItems(context),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Find Events-Hotels",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              "Palestine",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Stack(
          children: [
            const Icon(Icons.notifications_none, size: 28),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Container(
      key: searchKey,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: viewModel.searchController,
              decoration: const InputDecoration(
                hintText: "Search by location (e.g. Jerusalem)",
                border: InputBorder.none,
              ),
              onChanged: (value) => viewModel.updateSearchQuery(value),
              onSubmitted: (_) => _performSearch(context),
            ),
          ),
          if (viewModel.searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: viewModel.clearSearch,
            ),
        ],
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _performSearch(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Search'),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming Events",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Column(
          children:
              viewModel.upcomingEvents.map((event) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final doc =
                            await FirebaseFirestore.instance
                                .collection('event')
                                .doc(event.id)
                                .get();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => EventDetailsPage(
                                  event: doc.data() ?? {},
                                  eventId: event.id,
                                  isInitiallyLiked: event.isFavorite,
                                ),
                          ),
                        );
                      },
                      child: _buildEventCard(
                        event.title,
                        event.subtitle,
                        event.imageUrl,
                        event.description,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildPopularHotels(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hotels Popular Now",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children:
                viewModel.popularHotels.map((hotel) {
                  return GestureDetector(
                    onTap: () async {
                      final doc =
                          await FirebaseFirestore.instance
                              .collection('hotel')
                              .doc(hotel.id)
                              .get();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => HotelDetailsPage(
                                hotel: doc.data() ?? {},
                                hotelId: hotel.id,
                                isInitiallyLiked: hotel.isFavorite,
                              ),
                        ),
                      );
                    },
                    child: _buildHotelCard(
                      hotel.title,
                      hotel.subtitle,
                      hotel.imageUrl,
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedItems(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recommended for You",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Column(
          children:
              viewModel.recommendedItems.map((item) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        try {
                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (context) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          );

                          if (item.type == 'hotel') {
                            // Fetch hotel details
                            final doc =
                                await FirebaseFirestore.instance
                                    .collection('hotel')
                                    .doc(item.id)
                                    .get();

                            // Close loading dialog
                            Navigator.of(context).pop();

                            if (doc.exists) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => HotelDetailsPage(
                                        hotel: doc.data() ?? {},
                                        hotelId: item.id,
                                        isInitiallyLiked: item.isFavorite,
                                      ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Hotel details not found'),
                                ),
                              );
                            }
                          } else {
                            // Fetch event details
                            final doc =
                                await FirebaseFirestore.instance
                                    .collection('event')
                                    .doc(item.id)
                                    .get();

                            // Close loading dialog
                            Navigator.of(context).pop();

                            if (doc.exists) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => EventDetailsPage(
                                        event: doc.data() ?? {},
                                        eventId: item.id,
                                        isInitiallyLiked: item.isFavorite,
                                      ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Event details not found'),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          // Close loading dialog if still open
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                      child: _buildRecommendedCard(
                        item.title,
                        item.subtitle,
                        item.imageUrl,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildEventCard(
    String title,
    String subtitle,
    String imageUrl,
    String description,
  ) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 120,
                    width: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
                minimumSize: const Size(6, 30),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Join"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(String title, String subtitle, String imageUrl) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 100,
              width: 160,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 100,
                    width: 160,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCard(String title, String subtitle, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
