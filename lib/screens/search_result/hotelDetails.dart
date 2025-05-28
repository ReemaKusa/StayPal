
// <<<<<<< HEAD
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:cached_network_image/cached_network_image.dart';


// // class HotelDetailsPage extends StatefulWidget {
// //   final Map<String, dynamic> hotel;
// //   final String hotelId;
// //   final bool isInitiallyLiked;
// =======
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:staypal/screens/auth/auth_entry_screen.dart';

// class HotelDetailsPage extends StatefulWidget {
//   final dynamic hotel;
//   final String hotelId;
//   final bool isInitiallyLiked;
// >>>>>>> 3fc82eca9865983f604a62878a53ac841fadaab0

// //   const HotelDetailsPage({
// //     super.key,
// //     required this.hotel,
// //     required this.hotelId,
// //     this.isInitiallyLiked = false,
// //   });

// //   @override
// //   State<HotelDetailsPage> createState() => _HotelDetailsPageState();
// // }

// // class _HotelDetailsPageState extends State<HotelDetailsPage> {
// //   late bool _isLiked;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _isLiked = widget.isInitiallyLiked;
// //   }

// //   void _onItemTapped(BuildContext context, int index) {
// //     if (index == 0) {
// //       Navigator.pushReplacementNamed(context, '/home');
// //     } else if (index == 2) {
// //       Navigator.pushReplacementNamed(context, '/wishlist');
// //     } else if (index == 3) {
// //       Navigator.pushReplacementNamed(context, '/profile');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final name = widget.hotel['name'] ?? 'Hotel Details';
// //     final location = widget.hotel['location'] ?? 'Unknown Location';
// //     final price = widget.hotel['price']?.toString() ?? 'N/A';
// //     final description = widget.hotel['description'] ?? 'No description available';
// //     final rating = widget.hotel['rating']?.toString() ?? 'N/A';
// //     final details = widget.hotel['details'] ?? 'No details available';
// //     final facilities = widget.hotel['facilities'] is List ? widget.hotel['facilities'] : [];
// //     final images = widget.hotel['images'] is List ? widget.hotel['images'] : [];
// //    final bool isFavorite = widget.hotel['isFavorite'] ?? false;


// <<<<<<< HEAD
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(name),
// //         backgroundColor: Colors.orange,
// //         actions: [
// //           IconButton(
// //             icon: Icon(
// //               _isLiked ? Icons.favorite : Icons.favorite_border,
// //               color: _isLiked ? Colors.red : Colors.black,
// //             ),
// //             onPressed: () {
// //               setState(() {
// //                 _isLiked = !_isLiked;
// //               });
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(
// //                   content: Text(_isLiked ? 'Added to favorites' : 'Removed from favorites'),
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //       bottomNavigationBar: BottomNavigationBar(
// //         type: BottomNavigationBarType.fixed,
// //         selectedItemColor: Colors.deepOrange,
// //         unselectedItemColor: Colors.grey,
// //         currentIndex: 0,
// //         onTap: (index) => _onItemTapped(context, index),
// //         items: const [
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
// //           BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
// //         ],
// //       ),
// //       body: SingleChildScrollView(
// //         child: Center(
// //           child: Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 _buildDetailImage(images.isNotEmpty ? images[0] : null),
// //                 const SizedBox(height: 20),
// //                 Text(
// //                   name,
// //                   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //                   textAlign: TextAlign.center,
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const Icon(Icons.location_on, color: Colors.orange),
// //                     const SizedBox(width: 4),
// //                     Text(location),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Text(
// //                   '$price ₪ per night',
// //                   style: const TextStyle(
// //                     fontSize: 22,
// //                     color: Colors.orange,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 20),
// //                   child: Text(
// //                     description,
// //                     style: const TextStyle(fontSize: 16),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     showModalBottomSheet(
// //                       context: context,
// //                       shape: const RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
// //                       ),
// //                       isScrollControlled: true,
// //                       builder: (context) => DraggableScrollableSheet(
// //                         expand: false,
// //                         initialChildSize: 0.5,
// //                         maxChildSize: 0.8,
// //                         minChildSize: 0.3,
// //                         builder: (_, controller) => Padding(
// //                           padding: const EdgeInsets.all(16.0),
// //                           child: ListView(
// //                             controller: controller,
// //                             children: [
// //                               const Center(
// //                                 child: Icon(Icons.star, size: 40, color: Colors.orange),
// //                               ),
// //                               const SizedBox(height: 10),
// //                               Text(
// //                                 "Rating: $rating",
// //                                 style: const TextStyle(fontSize: 18),
// //                                 textAlign: TextAlign.center,
// //                               ),
// //                               const SizedBox(height: 20),
// //                               Text(
// //                                 details,
// //                                 style: const TextStyle(fontSize: 16),
// //                                 textAlign: TextAlign.justify,
// //                               ),
// //                               const SizedBox(height: 20),
// //                               const Text(
// //                                 "Facilities:",
// //                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                                 textAlign: TextAlign.left,
// //                               ),
// //                               const SizedBox(height: 10),
// //                               ...facilities.map<Widget>((facility) => 
// //                                 Padding(
// //                                   padding: const EdgeInsets.symmetric(vertical: 4),
// //                                   child: Row(
// //                                     children: [
// //                                       const Icon(Icons.check, color: Colors.orange),
// //                                       const SizedBox(width: 8),
// //                                       Text(facility.toString()),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ).toList(),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.orange,
// //                     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                   child: const Text('More Details', style: TextStyle(fontSize: 18)),
// //                 ),
// //                 const SizedBox(height: 15),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     showDialog(
// //                       context: context,
// //                       builder: (context) => AlertDialog(
// //                         title: const Text('Book Hotel'),
// //                         content: const Text('Confirm your booking for this hotel?'),
// //                         actions: [
// //                           TextButton(
// //                             onPressed: () => Navigator.pop(context),
// //                             child: const Text('Cancel'),
// //                           ),
// //                           ElevatedButton(
// //                             onPressed: () async {
// //                               try {
// //                                 await FirebaseFirestore.instance
// //                                     .collection('bookings')
// //                                     .add({
// //                                   'hotelId': widget.hotelId,
// //                                   'userId': 'currentUserId', 
// //                                   'createdAt': FieldValue.serverTimestamp(),
// //                                   'status': 'pending',
// //                                 });
// //                                 Navigator.pop(context);
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   const SnackBar(
// //                                     content: Text('Booking successful!'),
// //                                   ),
// //                                 );
// //                               } catch (e) {
// //                                 Navigator.pop(context);
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   SnackBar(
// //                                     content: Text('Error: $e'),
// //                                   ),
// //                                 );
// //                               }
// //                             },
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Colors.deepOrange,
// //                             ),
// //                             child: const Text('Confirm'),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.deepOrange,
// //                     padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                   child: const Text('Book Now', style: TextStyle(fontSize: 18)),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// =======
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(name),
//         backgroundColor: Colors.orange,
//         actions: [
//           IconButton(
//             icon: Icon(
//               _isLiked ? Icons.favorite : Icons.favorite_border,
//               color: _isLiked ? Colors.red : Colors.black,
//             ),
//             onPressed: () {
//               setState(() {
//                 _isLiked = !_isLiked;
//               });
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(_isLiked ? 'Added to favorites' : 'Removed from favorites'),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.deepOrange,
//         unselectedItemColor: Colors.grey,
//         currentIndex: 0,
//         onTap: (index) => _onItemTapped(context, index),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 _buildDetailImage(images.isNotEmpty ? images[0] : null),
//                 const SizedBox(height: 20),
//                 Text(
//                   name,
//                   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.location_on, color: Colors.orange),
//                     const SizedBox(width: 4),
//                     Text(location),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   '$price ₪ per night',
//                   style: const TextStyle(
//                     fontSize: 22,
//                     color: Colors.orange,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Text(
//                     description,
//                     style: const TextStyle(fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     showModalBottomSheet(
//                       context: context,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//                       ),
//                       isScrollControlled: true,
//                       builder: (context) => DraggableScrollableSheet(
//                         expand: false,
//                         initialChildSize: 0.5,
//                         maxChildSize: 0.8,
//                         minChildSize: 0.3,
//                         builder: (_, controller) => Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: ListView(
//                             controller: controller,
//                             children: [
//                               const Center(
//                                 child: Icon(Icons.star, size: 40, color: Colors.orange),
//                               ),
//                               const SizedBox(height: 10),
//                               Text(
//                                 "Rating: $rating",
//                                 style: const TextStyle(fontSize: 18),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 20),
//                               Text(
//                                 details,
//                                 style: const TextStyle(fontSize: 16),
//                                 textAlign: TextAlign.justify,
//                               ),
//                               const SizedBox(height: 20),
//                               const Text(
//                                 "Facilities:",
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                                 textAlign: TextAlign.left,
//                               ),
//                               const SizedBox(height: 10),
//                               ...facilities.map<Widget>((facility) => 
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(vertical: 4),
//                                   child: Row(
//                                     children: [
//                                       const Icon(Icons.check, color: Colors.orange),
//                                       const SizedBox(width: 8),
//                                       Text(facility.toString()),
//                                     ],
//                                   ),
//                                 ),
//                               ).toList(),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text('More Details', style: TextStyle(fontSize: 18)),
//                 ),
//                 const SizedBox(height: 15),
//                 ElevatedButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: const Text('Book Hotel'),
//                         content: const Text('Confirm your booking for this hotel?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text('Cancel'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () async {
//                               final user = FirebaseAuth.instance.currentUser;

//                               if (user == null) {
//                                 Navigator.pop(context);
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: const Text('Not Logged In'),
//                                     content: const Text('You must be logged in to book this hotel.'),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () => Navigator.pop(context),
//                                         child: const Text('Cancel'),
//                                       ),
//                                       ElevatedButton(
//                                         style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
//                                         onPressed: () {
//                                           Navigator.pop(context);
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(builder: (context) => const AuthEntryScreen()),
//                                           );
//                                         },
//                                         child: const Text('Log In'),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                                 return;
//                               }

//                               try {
//                                 await FirebaseFirestore.instance.collection('bookings').add({
//                                   'hotelId': widget.hotelId,
//                                   'userId': user.uid,
//                                   'createdAt': FieldValue.serverTimestamp(),
//                                   'status': 'pending',
//                                 });

//                                 Navigator.pop(context);
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Booking successful!'),
//                                   ),
//                                 );
//                               } catch (e) {
//                                 Navigator.pop(context);
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text('Error: $e')),
//                                 );
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.deepOrange,
//                             ),
//                             child: const Text('Confirm'),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepOrange,
//                     padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text('Book Now', style: TextStyle(fontSize: 18)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// >>>>>>> 3fc82eca9865983f604a62878a53ac841fadaab0

// //   Widget _buildDetailImage(String? imageUrl) {
// //     if (imageUrl == null || imageUrl.isEmpty) {
// //       return Container(
// //         width: double.infinity,
// //         height: 200,
// //         color: Colors.grey[200],
// //         child: const Icon(Icons.hotel, size: 100, color: Colors.grey),
// //       );
// //     }

// //     return ClipRRect(
// //       borderRadius: BorderRadius.circular(12),
// //       child: CachedNetworkImage(
// //         imageUrl: imageUrl,
// //         width: double.infinity,
// //         height: 200,
// //         fit: BoxFit.cover,
// //         placeholder: (context, url) => Container(
// //           height: 200,
// //           color: Colors.grey[200],
// //           child: const Center(child: CircularProgressIndicator()),
// //         ),
// //         errorWidget: (context, url, error) => Container(
// //           height: 200,
// //           color: Colors.grey[200],
// //           child: const Icon(Icons.hotel, size: 100, color: Colors.grey),
// //         ),
// //       ),
// //     );
// //   }
// // }
