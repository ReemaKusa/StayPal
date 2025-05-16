import 'package:flutter/material.dart';

/*void main() {
  runApp(WishlistApp());
}

class WishlistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WishlistPage(),
    );
  }
}*/

class WishListPage extends StatelessWidget {
  final List<Map<String, String>> wishListItems = [
    {
      'title': 'Luxury Hotel',
      'subtitle': 'Nablus • Jun 20',
      'imageUrl': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
      'description': 'Enjoy a luxury experience with 5-star service and beautiful views in the heart of Nablus.',
    },
    {
      'title': 'Summer Festival',
      'subtitle': 'Gaza City • Jul 10',
      'imageUrl': 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
      'description': 'A summer event filled with music, dance, and unforgettable vibes.',
    },
    {
      'title': 'Romantic Escape Hotel',
      'subtitle': 'Bethlehem • Aug 5',
      'imageUrl': 'https://images.unsplash.com/photo-1607746882042-944635dfe10e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
      'description': 'Perfect for couples — cozy rooms, candlelight dinners, and historic scenery.',
    },
    {
      'title': 'Desert Adventure',
      'subtitle': 'Jericho • Sep 12',
      'imageUrl': 'https://images.unsplash.com/photo-1586074299733-6201a45e4bd4?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
      'description': 'Explore the stunning desert views and ride camels through breathtaking landscapes.',
    },
    {
      'title': 'City Lights Festival',
      'subtitle': 'Ramallah • Oct 3',
      'imageUrl': 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
      'description': 'Celebrate life with music, food, and vibrant street performances under the city lights.',
    },
        {
      'title': 'City Lights Festival',
      'subtitle': 'Ramallah • Oct 3',
      'imageUrl': 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
      'description': 'Celebrate life with music, food, and vibrant street performances under the city lights.',
    },
        {
      'title': 'City Lights Festival',
      'subtitle': 'Ramallah • Oct 3',
      'imageUrl': 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
      'description': 'Celebrate life with music, food, and vibrant street performances under the city lights.',
    },
        {
      'title': 'City Lights Festival',
      'subtitle': 'Ramallah • Oct 3',
      'imageUrl': 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
      'description': 'Celebrate life with music, food, and vibrant street performances under the city lights.',
    },
        {
      'title': 'City Lights Festival',
      'subtitle': 'Ramallah • Oct 3',
      'imageUrl': 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
      'description': 'Celebrate life with music, food, and vibrant street performances under the city lights.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
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
        title: Align(
          alignment: Alignment.centerLeft, // Changed from center to left
          child: Text(
            'My Wishlist',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24, // Slightly larger
              fontWeight: FontWeight.w600, // Semi-bold
            ),
          ),
        ),
        centerTitle: false, // Changed from true to false
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 28),
                  onPressed: () {
                    // Add notification logic
                  },
                ),
                Positioned(
                  right: 10,
                  top: 10,
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
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Removed the profile avatar from here since we moved notification to appBar
          const SizedBox(height: 8), // Reduced from 16 to 8

          // Wishlist cards
          ...wishListItems.map((item) => GestureDetector(
                onTap: () => _showDetailsBottomSheet(context, item),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                          item['imageUrl']!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[200],
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
                                item['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16, // Slightly larger
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['subtitle']!,
                                style: TextStyle(
                                  color: Colors.grey[600], // Darker grey
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'remove') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${item['title']} removed from wishlist')),
                            );
                          } else if (value == 'share') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sharing ${item['title']}...')),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(value: 'remove', child: Text('Remove')),
                          const PopupMenuItem(value: 'share', child: Text('Share')),
                        ],
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _showDetailsBottomSheet(BuildContext context, Map<String, String> item) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white, // <--- move this here
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item['title']!,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['subtitle']!,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item['imageUrl']!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.image, color: Colors.grey)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item['description']!,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "More Details",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}