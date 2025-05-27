// <<<<<<< HEAD
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../search_result/hotel/hotel_details_view.dart';
// import '../search_result/hotel/hotel_details_viewmodel.dart';
// import '../search_result/hotel/hotel_details_model.dart';
// import '../search_result/event/event_details_view.dart';
// =======
// // // The Dynmaic V of the Home P after the Static one was pushed

// // import 'package:flutter/material.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import '../search_result/hotelDetails.dart';
// // import '../search_result/eventDetails.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:staypal/screens/auth/auth_entry_screen.dart';
// // import '../../widgets/custom_nav_bar.dart';
// >>>>>>> 3fc82eca9865983f604a62878a53ac841fadaab0

// // class HomePage extends StatefulWidget {
// //   final GlobalKey _searchKey = GlobalKey();
// //   @override
// //   _HomePageState createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   List<Map<String, dynamic>> upcomingEvents = [];
// //   List<Map<String, dynamic>> popularHotels = [];
// //   List<Map<String, dynamic>> recommendedItems = [];
// //   bool isLoading = true;
// //   final GlobalKey _searchKey = GlobalKey();
// //   final TextEditingController _searchController = TextEditingController();
// //   String _searchQuery = '';
// //   final ScrollController _scrollController = ScrollController();

// //   void _scrollToSearch() {
// //     if (_searchKey.currentContext != null) {
// //       Scrollable.ensureVisible(
// //         _searchKey.currentContext!,
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.easeOut,
// //       );
// //     }
// //   }

// <<<<<<< HEAD
//   List<String> _convertToList(dynamic value) {
//     if (value == null) return [];
//     if (value is List) return List<String>.from(value);
//     if (value is String) return [value];
//     return [];
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }
// =======
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchData();
// //   }
// >>>>>>> 3fc82eca9865983f604a62878a53ac841fadaab0

// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     super.dispose();
// //   }

// <<<<<<< HEAD
//  List<String> _ensureList(dynamic value) {
//     if (value == null) return [];
//     if (value is List) return List<String>.from(value.whereType<String>());
//     if (value is String) return [value];
//     return [];
//   }

//   // دالة مساعدة للحصول على أول عنصر من قائمة أو قيمة افتراضية
//   String _getFirstImage(dynamic value) {
//     final list = _ensureList(value);
//     return list.isNotEmpty ? list.first : '';
//   }

//   Future<void> _fetchData() async {
//     try {
//       final eventsSnapshot = await FirebaseFirestore.instance
//           .collection('upcomingEvents')
//           .get();
//       final hotelsSnapshot = await FirebaseFirestore.instance
//           .collection('popularHotels')
//           .get();
//       final recommendedSnapshot = await FirebaseFirestore.instance
//           .collection('recommendedItems')
//           .get();

//       setState(() {
//         upcomingEvents = eventsSnapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'title': data['title']?.toString() ?? 'No Title',
//             'subtitle': data['subtitle']?.toString() ?? 'No Subtitle',
//             'imageUrl': _getFirstImage(data['imageUrl']),
//             'description': data['description']?.toString() ?? 'No Description',
//             'highlights': _ensureList(data['highlights']),
//             'date': data['date']?.toString() ?? 'No Date',
//             'time': data['time']?.toString() ?? 'No Time',
//             'price': (data['price'] as num?)?.toDouble() ?? 0.0,
//             'rating': (data['rating'] as num?)?.toDouble() ?? 0.0,
//             'isFavorite': data['isFavorite'] ?? false,
//           };
//         }).toList();

//         popularHotels = hotelsSnapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'title': data['title']?.toString() ?? 'No Title',
//             'subtitle': data['subtitle']?.toString() ?? 'No Location',
//             'imageUrl': _getFirstImage(data['imageUrl']),
//             'price': (data['price'] as num?)?.toDouble() ?? 0.0,
//             'description': data['description']?.toString() ?? 'No Description',
//             'rating': (data['rating'] as num?)?.toDouble() ?? 0.0,
//             'details': data['details']?.toString() ?? 'No Details',
//             'facilities': _ensureList(data['facilities']),
//             'isFavorite': data['isFavorite'] ?? false,
//           };
//         }).toList();

//         recommendedItems = recommendedSnapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'type': data['type']?.toString() ?? 'event',
//             'title': data['title']?.toString() ?? 'No Title',
//             'subtitle': data['subtitle']?.toString() ?? 'No Subtitle',
//             'imageUrl': _getFirstImage(data['imageUrl']),
//             'price': (data['price'] as num?)?.toDouble() ?? 0.0,
//             'description': data['description']?.toString() ?? 'No Description',
//             'rating': (data['rating'] as num?)?.toDouble() ?? 0.0,
//             'details': data['details']?.toString() ?? 'No Details',
//             'facilities': _ensureList(data['facilities']),
//             'isFavorite': data['isFavorite'] ?? false,
//           };
//         }).toList();

//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error fetching data: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// =======
// //   void _fetchData() async {
// //     try {
// //       final eventsQuery =
// //           await FirebaseFirestore.instance.collection('upcomingEvents').get();
// //       final hotelsQuery =
// //           await FirebaseFirestore.instance.collection('popularHotels').get();
// //       final recommendedQuery =
// //           await FirebaseFirestore.instance.collection('recommendedItems').get();

// //       setState(() {
// //         upcomingEvents =
// //             eventsQuery.docs
// //                 .map((doc) => {'id': doc.id, ...doc.data()})
// //                 .toList();
// //         popularHotels =
// //             hotelsQuery.docs
// //                 .map((doc) => {'id': doc.id, ...doc.data()})
// //                 .toList();
// //         recommendedItems =
// //             recommendedQuery.docs
// //                 .map((doc) => {'id': doc.id, ...doc.data()})
// //                 .toList();
// //         isLoading = false;
// //       });
// //     } catch (e) {
// //       print("Error fetching data: $e");
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
// >>>>>>> 3fc82eca9865983f604a62878a53ac841fadaab0

// //   void _performSearch() {
// //     final query = _searchQuery.trim();
// //     if (query.isEmpty) return;

// //     Navigator.pushNamed(
// //       context,
// //       '/searchresult',
// //       arguments: {'searchQuery': query, 'filterBy': 'location'},
// //     );

// //     _searchController.clear();
// //     setState(() {
// //       _searchQuery = '';
// //     });
// //   }

// <<<<<<< HEAD
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.deepOrange,
//         unselectedItemColor: Colors.grey,
//         currentIndex: 0,
//         onTap: (index) {
//           if (index == 1) {
//             Scrollable.ensureVisible(
//               widget._searchKey.currentContext!,
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.easeInOut,
//             );
//           } else if (index == 0) {
//             Navigator.pushNamed(context, '/home');
//           } else if (index == 2) {
//             Navigator.pushNamed(context, '/wishlist');
//           } else if (index == 3) {
//             Navigator.pushNamed(context, '/profile');
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildHeaderSection(),
//                       const SizedBox(height: 16),
//                       _buildSearchSection(),
//                       if (_searchQuery.isNotEmpty) ...[
//                         const SizedBox(height: 8),
//                         _buildSearchButton(),
//                       ],
//                       const SizedBox(height: 24),
//                       _buildSectionTitle("Upcoming Events"),
//                       const SizedBox(height: 12),
//                       _buildEventsList(),
//                       const SizedBox(height: 28),
//                       _buildSectionTitle("Hotels Popular Now"),
//                       const SizedBox(height: 12),
//                       _buildHotelsList(),
//                       const SizedBox(height: 28),
//                       _buildSectionTitle("Recommended for You"),
//                       const SizedBox(height: 12),
//                       _buildRecommendedList(),
//                     ],
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text("Find Events-Hotels", 
//                 style: TextStyle(fontSize: 16, color: Colors.grey)),
//             SizedBox(height: 4),
//             Text("Palestine, Nablus", 
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           ],
//         ),
//         Stack(
//           children: [
//             const Icon(Icons.notifications_none, size: 28),
//             Positioned(
//               right: 0,
//               top: 0,
//               child: Container(
//                 width: 10,
//                 height: 10,
//                 decoration: const BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildSearchSection() {
//     return Container(
//       key: widget._searchKey,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.search),
//           const SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 hintText: "Search by location (e.g. Jerusalem)",
//                 border: InputBorder.none,
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value;
//                 });
//               },
//               onSubmitted: (_) => _performSearch(),
//             ),
//           ),
//           if (_searchQuery.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.clear),
//               onPressed: () {
//                 _searchController.clear();
//                 setState(() {
//                   _searchQuery = '';
//                 });
//               },
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchButton() {
//     return ElevatedButton(
//       onPressed: _performSearch,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.deepOrange,
//         foregroundColor: Colors.white,
//         minimumSize: const Size(double.infinity, 48),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       child: const Text('Search'),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//     );
//   }

//   Widget _buildEventsList() {
//     return Column(
//       children: upcomingEvents.map((event) {
//         return Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => EventDetailsPage(
//                       event: event,
//                       eventId: event['id'],
//                       isInitiallyLiked: event['isFavorite'] ?? false,
//                     ),
//                   ),
//                 );
//               },
//               child: _buildEventCard(
//                 event['title'],
//                 event['subtitle'],
//                 event['imageUrl'],
//                 event['description'],
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildHotelsList() {
//     return SizedBox(
//       height: 200,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: popularHotels.map((hotel) {
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => HotelDetailsView(
//                     viewModel: HotelDetailsViewModel(
//                       HotelDetailsModel(
//                         hotelId: hotel['id'],
//                         hotel: {
//                           'name': hotel['title'],
//                           'location': hotel['subtitle'],
//                           'price': hotel['price'],
//                           'description': hotel['description'],
//                           'rating': hotel['rating'],
//                           'details': hotel['details'],
//                           'facilities': hotel['facilities'],
//                           'images': [hotel['imageUrl']],
//                           'isFavorite': hotel['isFavorite'] ?? false,
//                         },
//                         isInitiallyLiked: hotel['isFavorite'] ?? false,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//             child: _buildHotelCard(
//               hotel['title'],
//               hotel['subtitle'],
//               hotel['imageUrl'],
//               hotel['price'].toString(),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildRecommendedList() {
//     return Column(
//       children: recommendedItems.map((item) {
//         return Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 if (item['type'] == 'hotel') {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => HotelDetailsView(
//                         viewModel: HotelDetailsViewModel(
//                           HotelDetailsModel(
//                             hotelId: item['id'],
//                             hotel: {
//                               'name': item['title'],
//                               'location': item['subtitle'],
//                               'price': item['price'],
//                               'description': item['description'],
//                               'rating': item['rating'],
//                               'details': item['details'],
//                               'facilities': item['facilities'],
//                               'images': [item['imageUrl']],
//                               'isFavorite': item['isFavorite'] ?? false,
//                             },
//                             isInitiallyLiked: item['isFavorite'] ?? false,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 } else {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => EventDetailsPage(
//                         event: item,
//                         eventId: item['id'],
//                         isInitiallyLiked: item['isFavorite'] ?? false,
//                       ),
//                     ),
//                   );
//                 }
//               },
//               child: _buildRecommendedCard(
//                 item['title'],
//                 item['subtitle'],
//                 item['imageUrl'],
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildEventCard(String title, String subtitle, String imageUrl, String description) {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.grey[100],
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(16),
//               bottomLeft: Radius.circular(16),
//             ),
//             child: CachedNetworkImage(
//               imageUrl: imageUrl,
//               height: 120,
//               width: 120,
//               fit: BoxFit.cover,
//               placeholder: (context, url) => Container(
//                 height: 120,
//                 width: 120,
//                 color: Colors.grey[300],
//                 child: const Icon(Icons.image, color: Colors.grey),
//               ),
//               errorWidget: (context, url, error) => Container(
//                 height: 120,
//                 width: 120,
//                 color: Colors.grey[300],
//                 child: const Icon(Icons.error, color: Colors.grey),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 4),
//                 Text(subtitle, style: const TextStyle(color: Colors.grey)),
//                 const SizedBox(height: 8),
//                 Text(
//                   description,
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text("Join"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHotelCard(String title, String subtitle, String imageUrl, String price) {
//     return Container(
//       width: 160,
//       margin: const EdgeInsets.only(right: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.white,
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: CachedNetworkImage(
//               imageUrl: imageUrl,
//               height: 100,
//               width: 160,
//               fit: BoxFit.cover,
//               placeholder: (context, url) => Container(
//                 height: 100,
//                 width: 160,
//                 color: Colors.grey[300],
//                 child: const Icon(Icons.image, color: Colors.grey),
//               ),
//               errorWidget: (context, url, error) => Container(
//                 height: 100,
//                 width: 160,
//                 color: Colors.grey[300],
//                 child: const Icon(Icons.error, color: Colors.grey),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 4),
//                 Text(subtitle, style: const TextStyle(color: Colors.grey)),
//                 const SizedBox(height: 4),
//                 Text(
//                   '$price ₪ per night',
//                   style: const TextStyle(
//                     color: Colors.orange,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecommendedCard(String title, String subtitle, String imageUrl) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.white,
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
//         ],
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(16),
//               bottomLeft: Radius.circular(16),
//             ),
//             child: CachedNetworkImage(
//               imageUrl: imageUrl,
//               height: 100,
//               width: 100,
//               fit: BoxFit.cover,
//               placeholder: (context, url) => Container(
//                 height: 100,
//                 width: 100,
//                 color: Colors.grey[300],
//                 child: const Icon(Icons.image, color: Colors.grey),
//               ),
//               errorWidget: (context, url, error) => Container(
//                 height: 100,
//                 width: 100,
//                 color: Colors.grey[300],
//                 child: const Icon(Icons.error, color: Colors.grey),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 4),
//                   Text(subtitle, style: const TextStyle(color: Colors.grey)),
//                 ],
//               ),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.all(12.0),
//             child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
// =======
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       bottomNavigationBar: CustomNavBar(
// //         currentIndex: 0,
// //         searchKey: _searchKey,
// //         onSearchPressed: _scrollToSearch,
// //       ),
// //       body: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child:
// //               isLoading
// //                   ? const Center(child: CircularProgressIndicator())
// //                   : SingleChildScrollView(
// //                     controller: _scrollController, 
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: const [
// //                                 Text(
// //                                   "Find Events-Hotels",
// //                                   style: TextStyle(
// //                                     fontSize: 16,
// //                                     color: Colors.grey,
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: 4),
// //                                 Text(
// //                                   "Palestine, Nablus",
// //                                   style: TextStyle(
// //                                     fontSize: 20,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                             Stack(
// //                               children: [
// //                                 const Icon(Icons.notifications_none, size: 28),
// //                                 Positioned(
// //                                   right: 0,
// //                                   top: 0,
// //                                   child: Container(
// //                                     width: 10,
// //                                     height: 10,
// //                                     decoration: const BoxDecoration(
// //                                       color: Colors.red,
// //                                       shape: BoxShape.circle,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 16),
// //                         Container(
// //                           key:
// //                               _searchKey,
// //                           padding: const EdgeInsets.symmetric(horizontal: 12),
// //                           decoration: BoxDecoration(
// //                             color: Colors.grey[200],
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               const Icon(Icons.search),
// //                               const SizedBox(width: 8),
// //                               Expanded(
// //                                 child: TextField(
// //                                   controller: _searchController,
// //                                   decoration: const InputDecoration(
// //                                     hintText:
// //                                         "Search by location (e.g. Jerusalem)",
// //                                     border: InputBorder.none,
// //                                   ),
// //                                   onChanged: (value) {
// //                                     setState(() {
// //                                       _searchQuery = value;
// //                                     });
// //                                   },
// //                                   onSubmitted: (_) => _performSearch(),
// //                                 ),
// //                               ),
// //                               if (_searchQuery.isNotEmpty)
// //                                 IconButton(
// //                                   icon: const Icon(Icons.clear),
// //                                   onPressed: () {
// //                                     _searchController.clear();
// //                                     setState(() {
// //                                       _searchQuery = '';
// //                                     });
// //                                   },
// //                                 ),
// //                             ],
// //                           ),
// //                         ),
// //                         if (_searchQuery.isNotEmpty) ...[
// //                           const SizedBox(height: 8),
// //                           ElevatedButton(
// //                             onPressed: _performSearch,
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Colors.deepOrange,
// //                               foregroundColor: Colors.white,
// //                               minimumSize: const Size(double.infinity, 48),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(12),
// //                               ),
// //                             ),
// //                             child: const Text('Search'),
// //                           ),
// //                         ],
// //                         const SizedBox(height: 24),
// //                         const Text(
// //                           "Upcoming Events",
// //                           style: TextStyle(
// //                             fontSize: 20,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 12),
// //                         Column(
// //                           children:
// //                               upcomingEvents.map((event) {
// //                                 return Column(
// //                                   children: [
// //                                     GestureDetector(
// //                                       onTap: () {
// //                                         Navigator.push(
// //                                           context,
// //                                           MaterialPageRoute(
// //                                             builder:
// //                                                 (_) => EventDetailsPage(
// //                                                   event: event,
// //                                                   eventId: event['id'],
// //                                                   isInitiallyLiked:
// //                                                       event['isFavorite'] ??
// //                                                       false,
// //                                                 ),
// //                                           ),
// //                                         );
// //                                       },
// //                                       child: _buildEventCard(
// //                                         event['title'],
// //                                         event['subtitle'],
// //                                         event['imageUrl'],
// //                                         event['description'],
// //                                       ),
// //                                     ),
// //                                     const SizedBox(height: 16),
// //                                   ],
// //                                 );
// //                               }).toList(),
// //                         ),
// //                         const SizedBox(height: 28),
// //                         const Text(
// //                           "Hotels Popular Now",
// //                           style: TextStyle(
// //                             fontSize: 20,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 12),
// //                         SizedBox(
// //                           height: 200,
// //                           child: ListView(
// //                             scrollDirection: Axis.horizontal,
// //                             children:
// //                                 popularHotels.map((hotel) {
// //                                   return GestureDetector(
// //                                     onTap: () {
// //                                       Navigator.push(
// //                                         context,
// //                                         MaterialPageRoute(
// //                                           builder:
// //                                               (_) => HotelDetailsPage(
// //                                                 hotel: hotel,
// //                                                 hotelId: hotel['id'],
// //                                                 isInitiallyLiked:
// //                                                     hotel['isFavorite'] ??
// //                                                     false,
// //                                               ),
// //                                         ),
// //                                       );
// //                                     },
// //                                     child: _buildHotelCard(
// //                                       hotel['title'],
// //                                       hotel['subtitle'],
// //                                       hotel['imageUrl'],
// //                                     ),
// //                                   );
// //                                 }).toList(),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 28),
// //                         const Text(
// //                           "Recommended for You",
// //                           style: TextStyle(
// //                             fontSize: 20,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 12),
// //                         Column(
// //                           children:
// //                               recommendedItems.map((item) {
// //                                 return Column(
// //                                   children: [
// //                                     GestureDetector(
// //                                       onTap: () {
// //                                         if (item['type'] == 'hotel') {
// //                                           Navigator.push(
// //                                             context,
// //                                             MaterialPageRoute(
// //                                               builder:
// //                                                   (_) => HotelDetailsPage(
// //                                                     hotel: item,
// //                                                     hotelId: item['id'],
// //                                                     isInitiallyLiked:
// //                                                         item['isFavorite'] ??
// //                                                         false,
// //                                                   ),
// //                                             ),
// //                                           );
// //                                         } else {
// //                                           Navigator.push(
// //                                             context,
// //                                             MaterialPageRoute(
// //                                               builder:
// //                                                   (_) => EventDetailsPage(
// //                                                     event: item,
// //                                                     eventId: item['id'],
// //                                                     isInitiallyLiked:
// //                                                         item['isFavorite'] ??
// //                                                         false,
// //                                                   ),
// //                                             ),
// //                                           );
// //                                         }
// //                                       },
// //                                       child: _buildRecommendedCard(
// //                                         item['title'],
// //                                         item['subtitle'],
// //                                         item['imageUrl'],
// //                                       ),
// //                                     ),
// //                                     const SizedBox(height: 16),
// //                                   ],
// //                                 );
// //                               }).toList(),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildEventCard(
// //     String title,
// //     String subtitle,
// //     String imageUrl,
// //     String description,
// //   ) {
// //     return Container(
// //       height: 120,
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(16),
// //         color: Colors.grey[100],
// //       ),
// //       child: Row(
// //         children: [
// //           ClipRRect(
// //             borderRadius: const BorderRadius.only(
// //               topLeft: Radius.circular(16),
// //               bottomLeft: Radius.circular(16),
// //             ),
// //             child: Image.network(
// //               imageUrl,
// //               height: 120,
// //               width: 120,
// //               fit: BoxFit.cover,
// //               errorBuilder:
// //                   (context, error, stackTrace) => Container(
// //                     height: 120,
// //                     width: 120,
// //                     color: Colors.grey[300],
// //                     child: const Icon(Icons.image, color: Colors.grey),
// //                   ),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   title,
// //                   style: const TextStyle(fontWeight: FontWeight.bold),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(subtitle, style: const TextStyle(color: Colors.grey)),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   description,
// //                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
// //                   maxLines: 2,
// //                   overflow: TextOverflow.ellipsis,
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(12.0),
// //             child: ElevatedButton(
// //               onPressed: () {},
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: const Color.fromRGBO(255, 87, 34, 1),
// //                 foregroundColor: Colors.white,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //               ),
// //               child: const Text("Join"),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildHotelCard(String title, String subtitle, String imageUrl) {
// //     return Container(
// //       width: 160,
// //       margin: const EdgeInsets.only(right: 16),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(16),
// //         color: Colors.white,
// //         boxShadow: const [
// //           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           ClipRRect(
// //             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
// //             child: Image.network(
// //               imageUrl,
// //               height: 100,
// //               width: 160,
// //               fit: BoxFit.cover,
// //               errorBuilder:
// //                   (context, error, stackTrace) => Container(
// //                     height: 100,
// //                     width: 160,
// //                     color: Colors.grey[300],
// //                     child: const Icon(Icons.image, color: Colors.grey),
// //                   ),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   title,
// //                   style: const TextStyle(fontWeight: FontWeight.bold),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(subtitle, style: const TextStyle(color: Colors.grey)),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildRecommendedCard(String title, String subtitle, String imageUrl) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(16),
// //         color: Colors.white,
// //         boxShadow: const [
// //           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           ClipRRect(
// //             borderRadius: const BorderRadius.only(
// //               topLeft: Radius.circular(16),
// //               bottomLeft: Radius.circular(16),
// //             ),
// //             child: Image.network(
// //               imageUrl,
// //               height: 100,
// //               width: 100,
// //               fit: BoxFit.cover,
// //               errorBuilder:
// //                   (context, error, stackTrace) => Container(
// //                     height: 100,
// //                     width: 100,
// //                     color: Colors.grey[300],
// //                     child: const Icon(Icons.image, color: Colors.grey),
// //                   ),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Padding(
// //               padding: const EdgeInsets.symmetric(vertical: 12),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     title,
// //                     style: const TextStyle(fontWeight: FontWeight.bold),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(subtitle, style: const TextStyle(color: Colors.grey)),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           const Padding(
// //             padding: EdgeInsets.all(12.0),
// //             child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// >>>>>>> 3fc82eca9865983f604a62878a53ac841fadaab0
