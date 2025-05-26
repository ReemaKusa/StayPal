import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../search_result/hotel/hotel_details_view.dart';
import '../search_result/event/event_details_view.dart';
import 'package:staypal/screens/search_result/hotel/hotel_details_model.dart';
import 'package:staypal/screens/search_result/hotel/hotel_details_viewmodel.dart';



class CombinedPage extends StatefulWidget {
  const CombinedPage({super.key});

  @override
  State<CombinedPage> createState() => _CombinedPageState();
}

class _CombinedPageState extends State<CombinedPage> {
  bool showHotels = true;
  final GlobalKey _searchKey = GlobalKey();
  int _selectedIndex = 1;
  final Map<String, bool> _hotelLikes = {};
  final Map<String, bool> _eventLikes = {};
  final CollectionReference hotelsCollection =
      FirebaseFirestore.instance.collection('hotel');
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('event');
  final CollectionReference wishlistCollection =
      FirebaseFirestore.instance.collection('wishlist_testing');

  String? _searchQuery;
  String? _filterBy;
  final String name = "Search Results";

  @override
  void initState() {
    super.initState();
    _initializeLikes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading favorites')),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
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
    if (date is Timestamp) return DateFormat('yyyy-MM-dd').format(date.toDate());
    if (date is String) return date;
    return 'Invalid Date';
  }

  Future<void> _toggleHotelLike(String id, Map<String, dynamic> hotel) async {
    final currentStatus = hotel['isFavorite'] ?? false;
    try {
      await hotelsCollection.doc(id).update({
        'isFavorite': !currentStatus,
      });
      if (mounted) {
        setState(() {
          hotel['isFavorite'] = !currentStatus;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update favorite status')),
        );
      }
    }
  }

  Future<void> _toggleEventLike(String id, Map<String, dynamic> event) async {
    final currentStatus = event['isFavorite'] ?? false;
    try {
      await eventsCollection.doc(id).update({
        'isFavorite': !currentStatus,
      });
      if (mounted) {
        setState(() {
          event['isFavorite'] = !currentStatus;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update favorite status')),
        );
      }
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
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.orange,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
              Positioned(
                right: 10,
                top: 10,
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
            child: showHotels
                ? _buildHotelList(_searchQuery, _filterBy)
                : _buildEventList(_searchQuery, _filterBy),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String label, bool active, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? Colors.orange : Colors.orange.shade200,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (c, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>;
            final id = doc.id;
            final images = data['images'] as List? ?? [];
            final imageUrl = (images.isNotEmpty && images[0] != null)
                ? images[0].toString()
                : '';
            final isLiked = data['isFavorite'] ?? false;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildRecommendedCard(
                data['name'] ?? 'No Name',
                data['location'] ?? 'Unknown',
                imageUrl,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                          builder: (_) => HotelDetailsView(
                            viewModel: HotelDetailsViewModel(
                              HotelDetailsModel(
                                hotelId: id,
                                hotel: data,
                                isInitiallyLiked: true,
                              ),
                            ),
                          ),
                        ),
                ),
                onLike: () => _toggleHotelLike(id, data),
                isLiked: isLiked,
                price: data['price']?.toString() ?? 'N/A',
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEventList(String? query, String? filterBy) {
    Query q = eventsCollection;
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
              query == null ? 'No events available' : 'No events for "$query"',
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (c, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>;
            final id = doc.id;
            final images = data['images'] as List? ?? [];
            final imageUrl = (images.isNotEmpty && images[0] != null)
                ? images[0].toString()
                : '';
            final date = _formatEventDate(data['date']);
            final isLiked = data['isFavorite'] ?? false;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildRecommendedCard(
                data['name'] ?? 'No Name',
                date,
                imageUrl,
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
                onLike: () => _toggleEventLike(id, data),
                isLiked: isLiked,
                price: data['price']?.toString() ?? 'N/A',
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecommendedCard(
    String title,
    String subtitle,
    String imageUrl, {
    required VoidCallback onTap,
    required VoidCallback onLike,
    required bool isLiked,
    required String price,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              child: imageUrl.isEmpty
                  ? Container(
                      height: 100,
                      width: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.grey),
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
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
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.grey)),
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
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: onLike,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}