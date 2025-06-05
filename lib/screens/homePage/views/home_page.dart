
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';
// import '../models/popular_hotels_model.dart';
// import '../models/recommended_item_model.dart';
// import '../models/upcoming_events_model.dart';
import '../../search_result/hotel/views/hotel_details_view.dart';
import '../../search_result/event/views/event_details_view.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/webNavBar/web_nav_bar.dart';
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
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    final query = viewModel.searchQuery.trim();
    if (query.isEmpty) return;

    Navigator.pushNamed(
      context,
      '/searchresult',
      arguments: {
        'searchQuery': query,
      },
    );
    viewModel.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel()..fetchData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: isWeb 
            ? null 
            : Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  return CustomNavBar(
                    currentIndex: 0,
                    searchKey: searchKey,
                    onSearchPressed: () => _scrollToSearch(context),
                  );
                },
              ),
        appBar: isWeb ? WebNavBar(currentIndex: 0) : null,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(isWeb ? 24 : 16),
            child: Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  controller: viewModel.scrollController,
                  child: isWeb 
                      ? _buildWebLayout(context, viewModel)
                      : _buildMobileLayout(context, viewModel),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, HomeViewModel viewModel) {
    return Column(
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
    );
  }

  Widget _buildWebLayout(BuildContext context, HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(isWeb: true),
        const SizedBox(height: 24),
        _buildSearchField(context, isWeb: true),
        if (viewModel.searchQuery.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildSearchButton(context),
        ],
        const SizedBox(height: 32),
        _buildWebUpcomingEvents(context),
        const SizedBox(height: 40),
        _buildWebPopularHotels(context),
        const SizedBox(height: 40),
        _buildWebRecommendedItems(context),
      ],
    );
  }

  Widget _buildHeader({bool isWeb = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Find Events-Hotels",
              style: TextStyle(
                fontSize: isWeb ? 18 : 16, 
                color: Colors.grey
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Palestine",
              style: TextStyle(
                fontSize: isWeb ? 24 : 20, 
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        if (!isWeb) // Only show notification icon on mobile
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

  Widget _buildSearchField(BuildContext context, {bool isWeb = false}) {
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
              decoration: InputDecoration(
                hintText: isWeb 
                    ? "Search for hotels, events, or locations..."
                    : "Search by location (e.g. Jerusalem)",
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
          children: viewModel.upcomingEvents.map((event) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final doc = await FirebaseFirestore.instance
                        .collection('event')
                        .doc(event.id)
                        .get();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailsPage(
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

  Widget _buildWebUpcomingEvents(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming Events",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 3.0,
          ),
          itemCount: viewModel.upcomingEvents.length,
          itemBuilder: (context, index) {
            final event = viewModel.upcomingEvents[index];
            return GestureDetector(
              onTap: () async {
                final doc = await FirebaseFirestore.instance
                    .collection('event')
                    .doc(event.id)
                    .get();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventDetailsPage(
                      event: doc.data() ?? {},
                      eventId: event.id,
                      isInitiallyLiked: event.isFavorite,
                    ),
                  ),
                );
              },
              child: _buildWebEventCard(
                event.title,
                event.subtitle,
                event.imageUrl,
                event.description,
              ),
            );
          },
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
            children: viewModel.popularHotels.map((hotel) {
              return GestureDetector(
                onTap: () async {
                  final doc = await FirebaseFirestore.instance
                      .collection('hotel')
                      .doc(hotel.id)
                      .get();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HotelDetailsPage(
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

  Widget _buildWebPopularHotels(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Popular Hotels",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemCount: viewModel.popularHotels.length,
          itemBuilder: (context, index) {
            final hotel = viewModel.popularHotels[index];
            return GestureDetector(
              onTap: () async {
                final doc = await FirebaseFirestore.instance
                    .collection('hotel')
                    .doc(hotel.id)
                    .get();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HotelDetailsPage(
                      hotel: doc.data() ?? {},
                      hotelId: hotel.id,
                      isInitiallyLiked: hotel.isFavorite,
                    ),
                  ),
                );
              },
              child: _buildWebHotelCard(
                hotel.title,
                hotel.subtitle,
                hotel.imageUrl,
              ),
            );
          },
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
          children: viewModel.recommendedItems.map((item) {
           /////////// print('Item tapped: ${item.title}, type: ${item.type}, id: ${item.id}');

            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                     if ((item.type ?? '').toLowerCase() == 'hotel') {
                        final doc = await FirebaseFirestore.instance
                            .collection('hotel')
                            .doc(item.id)
                            .get();

                        Navigator.of(context).pop();

                        if (doc.exists) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HotelDetailsPage(
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
                        final doc = await FirebaseFirestore.instance
                            .collection('event')
                            .doc(item.id)
                            .get();

                        Navigator.of(context).pop();

                        if (doc.exists) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EventDetailsPage(
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

  Widget _buildWebRecommendedItems(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recommended for You",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 3.5,
          ),
          itemCount: viewModel.recommendedItems.length,
          itemBuilder: (context, index) {
            final item = viewModel.recommendedItems[index];
            return GestureDetector(
              onTap: () async {
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  if (item.type == 'hotel') {
                    final doc = await FirebaseFirestore.instance
                        .collection('hotel')
                        .doc(item.id)
                        .get();

                    Navigator.of(context).pop();

                    if (doc.exists) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HotelDetailsPage(
                            hotel: doc.data() ?? {},
                            hotelId: item.id,
                            isInitiallyLiked: item.isFavorite,
                          ),
                        ),
                      );
                    }
                  } else {
                    final doc = await FirebaseFirestore.instance
                        .collection('event')
                        .doc(item.id)
                        .get();

                    Navigator.of(context).pop();

                    if (doc.exists) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventDetailsPage(
                            event: doc.data() ?? {},
                            eventId: item.id,
                            isInitiallyLiked: item.isFavorite,
                          ),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: _buildWebRecommendedCard(
                item.title,
                item.subtitle,
                item.imageUrl,
                item.type == 'hotel' ? Icons.hotel : Icons.event,
              ),
            );
          },
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
              errorBuilder: (context, error, stackTrace) => Container(
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

  Widget _buildWebEventCard(
    String title,
    String subtitle,
    String imageUrl,
    String description,
  ) {
    return Container(
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
              height: 160,
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 160,
                width: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
                minimumSize: const Size(100, 50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Join Event",
                style: TextStyle(fontSize: 16),
              ),
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
              errorBuilder: (context, error, stackTrace) => Container(
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

  Widget _buildWebHotelCard(String title, String subtitle, String imageUrl) {
    return Container(
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
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("View Hotel"),
                ),
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
              errorBuilder: (context, error, stackTrace) => Container(
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

  Widget _buildWebRecommendedCard(
    String title,
    String subtitle,
    String imageUrl,
    IconData icon,
  ) {
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
              height: 140,
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 140,
                width: 200,
                color: Colors.grey[300],
                child: Icon(icon, size: 50, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}