// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
//
// class MyRatingsManagerView extends StatefulWidget {
//   const MyRatingsManagerView({super.key});
//
//   @override
//   State<MyRatingsManagerView> createState() => _MyRatingsManagerViewState();
// }
//
// class _MyRatingsManagerViewState extends State<MyRatingsManagerView> {
//   final Map<String, String> _hotelNameCache = {};
//
//   Future<List<String>> fetchMyHotelIds() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception('User not logged in');
//
//     final snapshot = await FirebaseFirestore.instance
//         .collection('hotel')
//         .where('managerId', isEqualTo: user.uid)
//         .get();
//
//     return snapshot.docs.map((doc) => doc.id).toList();
//   }
//
//   Future<String> getHotelName(String hotelId) async {
//     if (_hotelNameCache.containsKey(hotelId)) {
//       return _hotelNameCache[hotelId]!;
//     }
//
//     final doc = await FirebaseFirestore.instance.collection('hotel').doc(hotelId).get();
//     final name = doc.data()?['name'] ?? 'Unknown Hotel';
//     _hotelNameCache[hotelId] = name;
//     return name;
//   }
//
//   Future<List<Map<String, dynamic>>> fetchHotelRatings() async {
//     final hotelIds = await fetchMyHotelIds();
//     if (hotelIds.isEmpty) return [];
//
//     final snapshot = await FirebaseFirestore.instance
//         .collection('service_reviews')
//         .where('serviceId', whereIn: hotelIds)
//         .where('serviceType', isEqualTo: 'hotel')
//         .orderBy('createdAt', descending: true)
//         .get();
//
//     final reviews = snapshot.docs.map((doc) {
//       final data = doc.data();
//       data['id'] = doc.id;
//       return data;
//     }).toList();
//
//     for (final review in reviews) {
//       final hotelName = await getHotelName(review['serviceId']);
//       review['hotelName'] = hotelName;
//     }
//
//     return reviews;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Hotel Reviews'),
//         backgroundColor: Colors.orange,
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchHotelRatings(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting)
//             return const Center(child: CircularProgressIndicator());
//           if (snapshot.hasError)
//             return Center(child: Text('Error: ${snapshot.error}'));
//
//           final reviews = snapshot.data ?? [];
//           if (reviews.isEmpty) return const Center(child: Text('No reviews found.'));
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: reviews.length,
//             itemBuilder: (context, index) {
//               final review = reviews[index];
//               final timestamp = review['createdAt'];
//               final formattedDate = timestamp is Timestamp
//                   ? DateFormat('yyyy-MM-dd • HH:mm').format(timestamp.toDate())
//                   : 'Unknown';
//
//               return Card(
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         review['hotelName'] ?? 'Hotel',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.orange,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         review['userName'] ?? 'Anonymous',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Text('Rating: ${review['rating']} ⭐️'),
//                       const SizedBox(height: 4),
//                       Text(review['comment'] ?? 'No comment.'),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Posted on: $formattedDate',
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyRatingsManagerView extends StatefulWidget {
  const MyRatingsManagerView({super.key});

  @override
  State<MyRatingsManagerView> createState() => _MyRatingsManagerViewState();
}

class _MyRatingsManagerViewState extends State<MyRatingsManagerView> {
  Future<List<String>> fetchMyHotelIds() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final snapshot = await FirebaseFirestore.instance
        .collection('hotel')
        .where('managerId', isEqualTo: user.uid)
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<Map<String, dynamic>>> fetchHotelRatings() async {
    final hotelIds = await fetchMyHotelIds();
    if (hotelIds.isEmpty) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('reviews') // ✅ Correct collection
        .where('serviceId', whereIn: hotelIds)
        .where('serviceType', isEqualTo: 'hotel')
        .orderBy('createdAt', descending: true)
        .get();

    final hotelMap = await fetchHotelNamesMap();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      data['hotelName'] = hotelMap[data['serviceId']] ?? 'Unknown Hotel';
      return data;
    }).toList();
  }

  Future<Map<String, String>> fetchHotelNamesMap() async {
    final snapshot = await FirebaseFirestore.instance.collection('hotel').get();
    return {
      for (var doc in snapshot.docs)
        doc.id: doc.data()['name'] ?? 'Unnamed Hotel'
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Hotel Reviews'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchHotelRatings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final reviews = snapshot.data ?? [];
          if (reviews.isEmpty) return const Center(child: Text('No reviews found.'));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review['userName'] ?? 'Anonymous', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Hotel: ${review['hotelName'] ?? 'Unknown'}'),
                      Text('Rating: ${review['rating']} ⭐️'),
                      const SizedBox(height: 4),
                      Text(review['comment'] ?? 'No comment.'),
                      const SizedBox(height: 4),
                      if (review['createdAt'] != null)
                        Text(
                          'Posted on: ${review['createdAt'].toDate().toString().split('.')[0]}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}