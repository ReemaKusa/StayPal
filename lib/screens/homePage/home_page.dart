import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/wishlist': (context) => WishlistPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final GlobalKey _searchKey = GlobalKey();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Scrollable.ensureVisible(
              _searchKey.currentContext!,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/wishlist');
          }
        },
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Find events-Hotels",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Palestine, Nablus",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                ),
                const SizedBox(height: 16),

                // Search Box
                Container(
                  key: _searchKey,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Search for events-hotels...",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "Upcoming Events",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    _buildEventCard(
                      "Art Festival 2025",
                      "Gaza City • May 30",
                      "https://images.unsplash.com/photo-1563298723-dcfebaa392e3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                      "Annual exhibition showcasing Palestinian artists",
                    ),
                    const SizedBox(height: 16),
                    _buildEventCard(
                      "Music Festival",
                      "Ramallah • Jun 5",
                      "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                      "Traditional and contemporary Palestinian music",
                    ),
                    const SizedBox(height: 16),
                    _buildEventCard(
                      "Food Expo",
                      "Bethlehem • Jun 12",
                      "https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                      "Taste authentic Palestinian cuisine",
                    ),
                    const SizedBox(height: 16),
                    _buildEventCard(
                      "Heritage Tour",
                      "Hebron • Jun 18",
                      "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                      "Explore historic Palestinian sites",
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                const Text(
                  "Hotels Popular Now",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildHotelCard(
                        "Grand Plaza",
                        "Nablus • \$120",
                        "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                      ),
                      _buildHotelCard(
                        "Sea View",
                        "Gaza • \$150",
                        "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                      ),
                      _buildHotelCard(
                        "Olive Tree",
                        "Ramallah • \$110",
                        "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                      ),
                      _buildHotelCard(
                        "Heritage Inn",
                        "Jericho • \$90",
                        "https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                      ),
                      _buildHotelCard(
                        "Mountain View",
                        "Hebron • \$130",
                        "https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                      ),
                      _buildHotelCard(
                        "Desert Oasis",
                        "Jenin • \$80",
                        "https://images.unsplash.com/photo-1444201983204-c43cbd584d93?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  "Recommended for You",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    _buildRecommendedCard(
                      "Cultural Tour",
                      "Nablus • Jun 8",
                      "https://images.unsplash.com/photo-1569437063952-e0d7d0aa45e2?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                    ),
                    const SizedBox(height: 16),
                    _buildRecommendedCard(
                      "Cooking Class",
                      "Bethlehem • Jun 15",
                      "https://images.unsplash.com/photo-1547592180-85f173990554?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                    ),
                    const SizedBox(height: 16),
                    _buildRecommendedCard(
                      "Hiking Trip",
                      "Jericho • Jun 22",
                      "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                    ),
                    const SizedBox(height: 16),
                    _buildRecommendedCard(
                      "Wine Tasting",
                      "Ramallah • Jun 29",
                      "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                    ),
                    const SizedBox(height: 16),
                    _buildRecommendedCard(
                      "Photography Walk",
                      "Hebron • Jul 6",
                      "https://images.unsplash.com/photo-1506929562872-bb421503ef21?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
      ),
      body: const Center(child: Text('Wishlist items will appear here')),
    );
  }
}
