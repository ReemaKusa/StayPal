import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../search_result/hotelDetails.dart';
import '../search_result/eventDetails.dart';

class CombinedPage extends StatefulWidget {
  const CombinedPage({super.key});

//   @override
//   State<CombinedPage> createState() => _CombinedPageState();
// }

class _CombinedPageState extends State<CombinedPage> {
  bool showHotels = true;
  final GlobalKey _searchKey = GlobalKey();
  int _selectedIndex = 1;
  final Map<String, bool> _hotelLikes = {};
  final Map<String, bool> _eventLikes = {};

  final CollectionReference hotelsCollection = FirebaseFirestore.instance
      .collection('hotel');
  final CollectionReference eventsCollection = FirebaseFirestore.instance
      .collection('event');
  final CollectionReference wishlistCollection = FirebaseFirestore.instance
      .collection('wishlist_testing');

  String? _searchQuery;
  String? _filterBy;

//   @override
//   void initState() {
//     super.initState();
//     _initializeLikes();
//   }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ——— Safe route arguments cast ———
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (_searchQuery == null && routeArgs is Map<String, dynamic>) {
      _searchQuery = routeArgs['searchQuery'] as String?;
      _filterBy = routeArgs['filterBy'] as String?;
    }
  }

  Future<void> _initializeLikes() async {
    try {
      final snapshot = await wishlistCollection.get();
      final hotelLikes = <String, bool>{};
      final eventLikes = <String, bool>{};
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final type = data['type'] as String?;
        if (type == 'hotel') hotelLikes[doc.id] = true;
        if (type == 'event') eventLikes[doc.id] = true;
      }
      if (mounted) {
        setState(() {
          _hotelLikes.addAll(hotelLikes);
          _eventLikes.addAll(eventLikes);
        });
      }
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading favorites')),
        );
    }
  }

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//     if (index == 1) {
//       Scrollable.ensureVisible(
//         _searchKey.currentContext!,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     } else if (index == 0) {
//       Navigator.pushReplacementNamed(context, '/home');
//     } else if (index == 2) {
//       Navigator.pushReplacementNamed(context, '/wishlist');
//     } else if (index == 3) {
//       Navigator.pushReplacementNamed(context, '/profile');
//     }
//   }

  String _formatEventDate(dynamic date) {
    if (date == null) return 'No Date';
    if (date is Timestamp)
      return DateFormat('yyyy-MM-dd').format(date.toDate());
    if (date is String) return date;
    return 'Invalid Date';
  }

  Future<void> _toggleHotelLike(String id, Map<String, dynamic> hotel) async {
    final currentStatus = hotel['isFavorite'] ?? false;
    try {
      await FirebaseFirestore.instance.collection('hotel').doc(id).update({
        'isFavorite': !currentStatus,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update favorite status')),
      );
    }
  }

  Future<void> _toggleEventLike(String id, Map<String, dynamic> event) async {
    final currentStatus = event['isFavorite'] ?? false;
    try {
      await FirebaseFirestore.instance.collection('event').doc(id).update({
        'isFavorite': !currentStatus,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update favorite status')),
      );
    }
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
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      appBar: AppBar(
        title:
            _searchQuery != null
                ? Text('Results for "$_searchQuery"')
                : const Text('Hotels & Events'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
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
                _tabButton(
                  'Hotels',
                  showHotels,
                  () => setState(() => showHotels = true),
                ),
                const SizedBox(width: 12),
                _tabButton(
                  'Events',
                  !showHotels,
                  () => setState(() => showHotels = false),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                showHotels
                    ? _buildHotelList(_searchQuery, _filterBy)
                    : _buildEventList(_searchQuery, _filterBy),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String label, bool active, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? Colors.orange : Colors.orange.shade200,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }

 Widget _buildHotelList(String? query, String? filterBy) {
    Query q = hotelsCollection;
    if (query != null && filterBy == 'location') {
      q = q.where('location', isEqualTo: query);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: q.snapshots(),
      builder: (ctx, snap) {
        if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return Center(
            child: Text(
              query == null ? 'No hotels available' : 'No hotels for "$query"',
            ),
          );
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (c, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>;
            final id = doc.id;
            final images = data['images'] is List ? data['images'] as List : [];
            final imageUrl = (images.isNotEmpty && images[0] != null)
                ? images[0].toString()
                : '';
            final isLiked = data['isFavorite'] ?? false;

            return _listingCard(
              title: data['name'] ?? 'No Name',
              subtitle: data['location'] ?? 'Unknown',
              price: data['price']?.toString() ?? 'N/A',
              imageUrl: imageUrl,
              isLiked: isLiked,
              onLike: () => _toggleHotelLike(id, data),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HotelDetailsPage(
                    hotel: data,
                    hotelId: id,
                    isInitiallyLiked: isLiked,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

//   Widget _buildEventList(String? query, String? filterBy) {
//     Query q = eventsCollection;
//     if (query != null && filterBy == 'location') {
//       q = q.where('location', isEqualTo: query);
//     }

    return StreamBuilder<QuerySnapshot>(
      stream: q.snapshots(),
      builder: (ctx, snap) {
        if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return Center(
            child: Text(
              query == null ? 'No events available' : 'No events for "$query"',
            ),
          );
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (c, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>;
            final id = doc.id;
            final images = data['images'] is List ? data['images'] as List : [];
            final imageUrl = (images.isNotEmpty && images[0] != null)
                ? images[0].toString()
                : '';
            final date = _formatEventDate(data['date']);
            final isLiked = data['isFavorite'] ?? false;

            return _listingCard(
              title: data['name'] ?? 'No Name',
              subtitle: date,
              price: data['price']?.toString() ?? 'N/A',
              imageUrl: imageUrl,
              isLiked: isLiked,
              onLike: () => _toggleEventLike(id, data),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventDetailsPage(
                    event: data,
                    eventId: id,
                    isInitiallyLiked: isLiked,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _listingCard({
    required String title,
    required String subtitle,
    required String price,
    required String imageUrl,
    required bool isLiked,
    required VoidCallback onLike,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
                child:
                    imageUrl.isEmpty
                        ? Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        )
                        : CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder:
                              (_, __) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
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
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: onLike,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle),
                    const SizedBox(height: 4),
                    Text(
                      '$price ₪',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
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
  }
}

Widget _buildEventImage(String imageUrl) {
  if (imageUrl.isEmpty) {
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
    placeholder:
        (context, url) => Container(
          width: 60,
          height: 60,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
    errorWidget:
        (context, url, error) => Container(
          width: 60,
          height: 60,
          color: Colors.grey[200],
          child: const Icon(Icons.event, size: 40, color: Colors.grey),
        ),
  );
}
