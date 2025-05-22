import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'hotelDetails.dart';
import 'eventDetails.dart';

class CombinedPage extends StatefulWidget {
  const CombinedPage({super.key});

  @override
  State<CombinedPage> createState() => _CombinedPageState();
}

class _CombinedPageState extends State<CombinedPage> {
  bool showHotels = true;
  final GlobalKey _searchKey = GlobalKey();
  int _selectedIndex = 0;
  final Map<String, bool> _hotelLikes = {};
  final Map<String, bool> _eventLikes = {};

  final CollectionReference hotelsCollection = 
      FirebaseFirestore.instance.collection('hotel');
  final CollectionReference eventsCollection = 
      FirebaseFirestore.instance.collection('event');

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Scrollable.ensureVisible(
        _searchKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/wishlist');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  String _formatEventDate(dynamic date) {
    if (date == null) return 'No Date';
    if (date is Timestamp) {
      return DateFormat('yyyy-MM-dd').format(date.toDate());
    }
    if (date is String) return date;
    return 'Invalid Date';
  }

  void _toggleHotelLike(String hotelId) {
    setState(() {
      _hotelLikes[hotelId] = !(_hotelLikes[hotelId] ?? false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_hotelLikes[hotelId]! ? 'Added to favorites' : 'Removed from favorites'),
      ),
    );
  }

  void _toggleEventLike(String eventId) {
    setState(() {
      _eventLikes[eventId] = !(_eventLikes[eventId] ?? false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_eventLikes[eventId]! ? 'Added to favorites' : 'Removed from favorites'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.black),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            key: _searchKey,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showHotels ? Colors.orange : Colors.orange.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => setState(() => showHotels = true),
                  child: const Text('Hotels'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !showHotels ? Colors.orange : Colors.orange.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => setState(() => showHotels = false),
                  child: const Text('Events'),
                ),
              ],
            ),
          ),
          Expanded(child: showHotels ? _buildHotelList() : _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildHotelList() {
    return StreamBuilder<QuerySnapshot>(
      stream: hotelsCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hotels available'));
        }

        final hotels = snapshot.data!.docs;

        return ListView.builder(
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotel = hotels[index].data() as Map<String, dynamic>;
            final hotelId = hotels[index].id;

            final name = hotel['name'] ?? 'No Name';
            final location = hotel['location'] ?? 'Unknown Location';
            final price = hotel['price']?.toString() ?? 'N/A';
            final images = hotel['images'] is List ? hotel['images'] : [];
            final isLiked = _hotelLikes[hotelId] ?? false;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelDetailsPage(
                      hotel: hotel,
                      hotelId: hotelId,
                      isInitiallyLiked: isLiked,
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildHotelImage(images.isNotEmpty ? images[0] : null),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: isLiked ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () => _toggleHotelLike(hotelId),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(location),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$price ₪',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHotelImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        color: Colors.grey[200],
        child: const Icon(Icons.hotel, size: 40, color: Colors.grey),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: 60,
        height: 60,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        width: 60,
        height: 60,
        color: Colors.grey[200],
        child: const Icon(Icons.hotel, size: 40, color: Colors.grey),
      ),
    );
  }

  Widget _buildEventList() {
    return StreamBuilder<QuerySnapshot>(
      stream: eventsCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No events available'));
        }

        final events = snapshot.data!.docs;

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index].data() as Map<String, dynamic>;
            final eventId = events[index].id;

            final name = event['name'] ?? 'No Name';
            final location = event['location'] ?? 'Unknown Location';
            final price = event['price']?.toString() ?? 'N/A';
            final images = event['images'] is List ? event['images'] : [];
            final date = _formatEventDate(event['date']);
            final isLiked = _eventLikes[eventId] ?? false;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsPage(
                      event: event,
                      eventId: eventId,
                      isInitiallyLiked: isLiked,
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildEventImage(images.isNotEmpty ? images[0] : null),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: isLiked ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () => _toggleEventLike(eventId),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(location),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(date),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$price ₪',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEventImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        color: Colors.grey[200],
        child: const Icon(Icons.event, size: 40, color: Colors.grey),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: 60,
        height: 60,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        width: 60,
        height: 60,
        color: Colors.grey[200],
        child: const Icon(Icons.event, size: 40, color: Colors.grey),
      ),
    );
  }
}