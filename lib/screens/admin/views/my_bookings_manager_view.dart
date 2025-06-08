import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/models/hotel_booking_model.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/widgets/drawer.dart';
import 'my_ratings_manager_view.dart';
import 'hotel_manager_view.dart';

class MyBookingsManagerView extends StatefulWidget {
  const MyBookingsManagerView({super.key});

  @override
  State<MyBookingsManagerView> createState() => _MyBookingsManagerViewState();
}

class _MyBookingsManagerViewState extends State<MyBookingsManagerView> {
  Future<List<String>> fetchMyHotelIds() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final snapshot = await FirebaseFirestore.instance
        .collection('hotel')
        .where('managerId', isEqualTo: user.uid)
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<HotelBookingModel>> fetchHotelBookings() async {
    final hotelIds = await fetchMyHotelIds();
    if (hotelIds.isEmpty) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('hotel_bookings')
        .where('hotelId', whereIn: hotelIds)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => HotelBookingModel.fromFirestore(doc)).toList();
  }

  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return doc.data() ?? {};
    } catch (_) {
      return {};
    }
  }

  Future<String> fetchHotelName(String hotelId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('hotel').doc(hotelId).get();
      return doc.data()?['name'] ?? 'Unknown Hotel';
    } catch (_) {
      return 'Unknown Hotel';
    }
  }

  Future<void> _updateBookingStatus(String bookingId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('hotel_bookings')
          .doc(bookingId)
          .update({'status': newStatus});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking $newStatus')),
      );

      setState(() {}); // Refresh UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: CustomRoleDrawer(
        roleTitle: 'Hotel Manager',
        optionTitle: 'My Hotels',
        optionIcon: Icons.hotel,
        onManageTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HotelManagerView()),
          );
        },
        onBookingsTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MyBookingsManagerView()),
          );
        },
        onReviewsTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MyRatingsManagerView()),
          );
        },
      ),
      appBar: AppBar(
        title: const Text('My Hotel Bookings'),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<HotelBookingModel>>(
        future: fetchHotelBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final bookings = snapshot.data ?? [];
          if (bookings.isEmpty) return const Center(child: Text('No bookings found.'));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return FutureBuilder(
                future: Future.wait([
                  fetchHotelName(booking.hotelId),
                  fetchUserDetails(booking.userId),
                ]),
                builder: (context, snap) {
                  if (!snap.hasData) return const SizedBox();
                  final hotelName = snap.data?[0] as String;
                  final user = snap.data?[1] as Map<String, dynamic>;
                  final userName = user['fullName'] ?? 'Unknown';
                  final userEmail = user['email'] ?? 'unknown@email.com';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(hotelName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('👤 $userName'),
                          Text('📧 $userEmail'),
                          const Divider(),
                          Text('Check-In: ${booking.formattedCheckIn}'),
                          Text('Check-Out: ${booking.formattedCheckOut}'),
                          Text('Status: ${booking.status}'),
                          Text('Total: ${booking.price.toStringAsFixed(2)} ₪'),
                          Text('Booked on: ${booking.formattedCreatedAt}'),
                          const SizedBox(height: 12),
                          if (booking.status == 'pending')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _updateBookingStatus(booking.bookingId, 'confirmed'),
                                  icon: const Icon(Icons.check),
                                  label: const Text('Confirm'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _updateBookingStatus(booking.bookingId, 'cancelled'),
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Cancel'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}