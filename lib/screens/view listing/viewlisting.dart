import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CombinedPage(),
    );
  }
}

class CombinedPage extends StatefulWidget {
  const CombinedPage({super.key});

  @override
  State<CombinedPage> createState() => _CombinedPageState();
}

class _CombinedPageState extends State<CombinedPage> {
  bool showHotels = true;

  final List<Map<String, dynamic>> hotels = [
    {
      'name': 'Moon Hotel',
      'images': ['assets/images/hotel1.jpg', 'assets/images/hotel2.jpg'],
      'location': 'Ramallah',
      'description': 'A wonderful hotel in the heart of Ramallah with a stunning view.',
      'price': '120',
      'isFavorite': false,
    },
    {
      'name': 'Palm Hotel',
      'images': ['assets/images/hotel1.jpg'],
      'location': 'Nablus',
      'description': 'Located downtown, close to all services.',
      'price': '90',
      'isFavorite': false,
    },
  ];

  final List<Map<String, dynamic>> events = [
    {
      'name': 'Music Festival',
      'images': ['assets/images/hotel1.jpg', 'assets/images/hotel2.jpg'],
      'location': 'Bethlehem',
      'date': '2025-06-20',
      'description': 'An amazing music event featuring local and international artists.',
      'price': '30',
      'isFavorite': false,
    },
    {
      'name': 'Art Expo',
      'images': ['assets/images/hotel1.jpg'],
      'location': 'Jericho',
      'date': '2025-07-05',
      'description': 'An exhibition showcasing contemporary Palestinian art.',
      'price': '20',
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية الصفحة بيضاء
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
    return ListView.builder(
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        final hotel = hotels[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HotelDetailPage(hotel: hotel)),
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
                    child: Image.asset(hotel['images'][0], width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hotel['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(hotel['location']),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // السعر باللون الأسود بدون أيقونة
                  Text(
                    '${hotel['price']} ₪',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventDetailPage(event: event)),
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
                    child: Image.asset(event['images'][0], width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(event['location']),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // السعر باللون الأسود بدون أيقونة
                  Text(
                    '${event['price']} ₪',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// صفحة تفاصيل الفندق مع السعر باللون الأسود بدون أيقونة واللون البرتقالي للخلفية
class HotelDetailPage extends StatefulWidget {
  final Map<String, dynamic> hotel;
  const HotelDetailPage({super.key, required this.hotel});

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;
    return Scaffold(
      backgroundColor: Colors.white, // الخلفية بيضاء
      appBar: AppBar(
        title: Text(hotel['name'], style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    hotel['images'][_currentImageIndex],
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 80,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _currentImageIndex =
                            ((_currentImageIndex - 1 + hotel['images'].length) % hotel['images'].length).toInt();
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 80,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _currentImageIndex =
                            ((_currentImageIndex + 1) % hotel['images'].length).toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.orange),
                const SizedBox(width: 4),
                Text(hotel['location']),
              ],
            ),
            const SizedBox(height: 16),
            // السعر باللون الأسود بدون أيقونة
            Text(
              '${hotel['price']} ₪',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(hotel['description'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: const SizedBox()),
                IconButton(
                  icon: Icon(
                    hotel['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                    color: hotel['isFavorite'] ? Colors.red : Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      hotel['isFavorite'] = !hotel['isFavorite'];
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Book Now'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('More Details'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// صفحة تفاصيل الحدث مع السعر باللون الأسود بدون أيقونة، أيقونة التاريخ باللون البرتقالي، والعنوان باللون الأبيض
class EventDetailPage extends StatefulWidget {
  final Map<String, dynamic> event;
  const EventDetailPage({super.key, required this.event});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    return Scaffold(
      backgroundColor: Colors.white, // الخلفية بيضاء
      appBar: AppBar(
        title: Text(event['name'], style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    event['images'][_currentImageIndex],
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 80,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _currentImageIndex =
                            ((_currentImageIndex - 1 + event['images'].length) % event['images'].length).toInt();
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 80,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _currentImageIndex =
                            ((_currentImageIndex + 1) % event['images'].length).toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.orange),
                const SizedBox(width: 4),
                Text(event['location']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.orange),
                const SizedBox(width: 6),
                Text(event['date']),
              ],
            ),
            const SizedBox(height: 16),
            // السعر باللون الأسود بدون أيقونة
            Text(
              '${event['price']} ₪',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(event['description'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: const SizedBox()),
                IconButton(
                  icon: Icon(
                    event['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                    color: event['isFavorite'] ? Colors.red : Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      event['isFavorite'] = !event['isFavorite'];
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
