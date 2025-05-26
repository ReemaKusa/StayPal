// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class EventDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> event;
//   final String eventId;
//   final bool isInitiallyLiked;

//   const EventDetailsPage({
//     super.key,
//     required this.event,
//     required this.eventId,
//     this.isInitiallyLiked = false,
//   });

//   @override
//   State<EventDetailsPage> createState() => _EventDetailsPageState();
// }

// class _EventDetailsPageState extends State<EventDetailsPage> {
//   int _ticketCount = 1;
//   double _totalPrice = 0;
//   bool _isLiked = false;
//   late String _currentUserId;
//   bool _isEventExpired = false;

//   @override
//   void initState() {
//     super.initState();
//     final eventPrice = widget.event['price'] is num
//         ? (widget.event['price'] as num).toDouble()
//         : 0.0;
//     _totalPrice = eventPrice;
//     _isLiked = widget.isInitiallyLiked;
//     _getCurrentUser();
//     _checkEventDate();
//   }

//   Future<void> _getCurrentUser() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         _currentUserId = user.uid;
//       });
//     }
//   }

//   void _checkEventDate() {
//     final date = widget.event['date'];
//     if (date == null) return;

//     DateTime eventDate;
//     if (date is Timestamp) {
//       eventDate = date.toDate();
//     } else if (date is String) {
//       try {
//         eventDate = DateTime.parse(date);
//       } catch (e) {
//         return;
//       }
//     } else {
//       return;
//     }

//     final now = DateTime.now();
//     setState(() {
//       _isEventExpired = eventDate.isBefore(now);
//     });
//   }

//   Future<void> _toggleLike() async {
//     try {
//       if (_isLiked) {
//         // Remove from favorites
//         final query = await FirebaseFirestore.instance
//             .collection('favorites')
//             .where('userId', isEqualTo: _currentUserId)
//             .where('itemId', isEqualTo: widget.eventId)
//             .where('type', isEqualTo: 'event')
//             .limit(1)
//             .get();

//         if (query.docs.isNotEmpty) {
//           await FirebaseFirestore.instance
//               .collection('favorites')
//               .doc(query.docs.first.id)
//               .delete();
//         }
//       } else {
//         // Add to favorites
//         await FirebaseFirestore.instance.collection('favorites').add({
//           'userId': _currentUserId,
//           'itemId': widget.eventId,
//           'type': 'event',
//           'isFavorite': true,
//           'createdAt': FieldValue.serverTimestamp(),
//           'eventData': widget.event,
//         });
//       }

//       setState(() {
//         _isLiked = !_isLiked;
//       });
//     } catch (e) {
//       print('Error toggling like: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update favorites: $e')),
//       );
//     }
//   }

//   String _formatDate(dynamic date) {
//     if (date == null) return 'No Date';
//     if (date is Timestamp) {
//       return DateFormat('yyyy-MM-dd').format(date.toDate());
//     }
//     if (date is String) return date;
//     return 'Invalid Date';
//   }

//   void _onItemTapped(BuildContext context, int index) {
//     if (index == 0) {
//       Navigator.pushReplacementNamed(context, '/home');
//     } else if (index == 2) {
//       Navigator.pushReplacementNamed(context, '/wishlist');
//     } else if (index == 3) {
//       Navigator.pushReplacementNamed(context, '/profile');
//     }
//   }

//   void _updateTicketCount(int newCount) {
//     final eventPrice = widget.event['price'] is num
//         ? (widget.event['price'] as num).toDouble()
//         : 0.0;
//     setState(() {
//       _ticketCount = newCount;
//       _totalPrice = eventPrice * _ticketCount;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final name = widget.event['name'] ?? 'Event Details';
//     final location = widget.event['location'] ?? 'Unknown Location';
//     final date = _formatDate(widget.event['date']);
//     final time = widget.event['time'] ?? 'No Time Specified';
//     final description = widget.event['description'] ?? 'No description available';
//     final rating = widget.event['rating']?.toString() ?? 'N/A';
//     final details = widget.event['details'] ?? 'No details available';
//     final highlights = widget.event['highlights'] is List ? widget.event['highlights'] : [];
//     final images = widget.event['images'] is List ? widget.event['images'] : [];
//     final price = widget.event['price'] is num
//         ? (widget.event['price'] as num).toDouble()
//         : 0.0;

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
//             onPressed: _toggleLike,
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
//                 if (_isEventExpired)
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(10),
//                     margin: const EdgeInsets.only(bottom: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.red[100],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.warning, color: Colors.red),
//                         SizedBox(width: 8),
//                         Text(
//                           'This event has already passed',
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
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
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.calendar_today, color: Colors.orange),
//                     const SizedBox(width: 4),
//                     Text(date),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.access_time, color: Colors.orange),
//                     const SizedBox(width: 4),
//                     Text(time),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     children: [
//                       const Text(
//                         'Number of Tickets',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.remove_circle_outline),
//                             color: Colors.orange,
//                             onPressed: () {
//                               if (_ticketCount > 1) {
//                                 _updateTicketCount(_ticketCount - 1);
//                               }
//                             },
//                           ),
//                           Container(
//                             width: 50,
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Text(
//                               '$_ticketCount',
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(fontSize: 18),
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.add_circle_outline),
//                             color: Colors.orange,
//                             onPressed: () {
//                               _updateTicketCount(_ticketCount + 1);
//                             },
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Price per ticket: ${price.toStringAsFixed(0)} ₪',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Total Price: ${_totalPrice.toStringAsFixed(0)} ₪',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepOrange,
//                         ),
//                       ),
//                     ],
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
//                   onPressed: _isEventExpired
//                       ? null
//                       : () {
//                           showModalBottomSheet(
//                             context: context,
//                             shape: const RoundedRectangleBorder(
//                               borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//                             ),
//                             isScrollControlled: true,
//                             builder: (context) => DraggableScrollableSheet(
//                               expand: false,
//                               initialChildSize: 0.5,
//                               maxChildSize: 0.8,
//                               minChildSize: 0.3,
//                               builder: (_, controller) => Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: ListView(
//                                   controller: controller,
//                                   children: [
//                                     const Center(
//                                       child: Icon(Icons.star, size: 40, color: Colors.orange),
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Text(
//                                       "Rating: $rating",
//                                       style: const TextStyle(fontSize: 18),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     const SizedBox(height: 20),
//                                     Text(
//                                       details,
//                                       style: const TextStyle(fontSize: 16),
//                                       textAlign: TextAlign.justify,
//                                     ),
//                                     const SizedBox(height: 20),
//                                     const Text(
//                                       "Event Highlights:",
//                                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                                       textAlign: TextAlign.left,
//                                     ),
//                                     const SizedBox(height: 10),
//                                     ...highlights.map<Widget>((highlight) => 
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(vertical: 4),
//                                         child: Row(
//                                           children: [
//                                             const Icon(Icons.check, color: Colors.orange),
//                                             const SizedBox(width: 8),
//                                             Text(highlight.toString()),
//                                           ],
//                                         ),
//                                       ),
//                                     ).toList(),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
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
//                   onPressed: _isEventExpired
//                       ? null
//                       : () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: const Text('Confirm Booking'),
//                               content: Text(
//                                   'You are about to book $_ticketCount tickets for ${_totalPrice.toStringAsFixed(0)} ₪'),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: const Text('Cancel'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     try {
//                                       await FirebaseFirestore.instance
//                                           .collection('bookings')
//                                           .add({
//                                         'eventId': widget.eventId,
//                                         'userId': _currentUserId,
//                                         'tickets': _ticketCount,
//                                         'totalPrice': _totalPrice,
//                                         'createdAt': FieldValue.serverTimestamp(),
//                                         'status': 'confirmed',
//                                       });
//                                       Navigator.pop(context);
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         const SnackBar(
//                                           content: Text('Booking successful!'),
//                                         ),
//                                       );
//                                     } catch (e) {
//                                       Navigator.pop(context);
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         SnackBar(
//                                           content: Text('Error: $e'),
//                                         ),
//                                       );
//                                     }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.deepOrange,
//                                   ),
//                                   child: const Text('Confirm'),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepOrange,
//                     padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text('Get Tickets', style: TextStyle(fontSize: 18)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailImage(String? imageUrl) {
//     if (imageUrl == null || imageUrl.isEmpty) {
//       return Container(
//         width: double.infinity,
//         height: 200,
//         color: Colors.grey[200],
//         child: const Icon(Icons.event, size: 100, color: Colors.grey),
//       );
//     }

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: CachedNetworkImage(
//         imageUrl: imageUrl,
//         width: double.infinity,
//         height: 200,
//         fit: BoxFit.cover,
//         placeholder: (context, url) => Container(
//           height: 200,
//           color: Colors.grey[200],
//           child: const Center(child: CircularProgressIndicator()),
//         ),
//         errorWidget: (context, url, error) => Container(
//           height: 200,
//           color: Colors.grey[200],
//           child: const Icon(Icons.event, size: 100, color: Colors.grey),
//         ),
//       ),
//     );
//   }
// } 