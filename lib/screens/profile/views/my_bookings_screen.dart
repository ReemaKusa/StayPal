import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/models/hotel_booking_model.dart';
import 'package:staypal/models/event_ticket_model.dart';
import 'package:intl/intl.dart';
import 'package:staypal/screens/detailsPage/hotel/views/hotel_details_view.dart';
import 'package:staypal/screens/detailsPage/event/views/event_details_view.dart';
import 'package:staypal/constants/color_constants.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  String _selectedType = 'hotel';

  Future<List<HotelBookingModel>> fetchHotelBookings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final snapshot = await FirebaseFirestore.instance
        .collection('hotel_bookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => HotelBookingModel.fromFirestore(doc)).toList();
  }

  Future<Map<String, dynamic>> fetchHotelDetails(String hotelId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('hotel').doc(hotelId).get();
      return doc.data() ?? {};
    } catch (_) {
      return {};
    }
  }

  Future<List<EventTicketModel>> fetchEventTickets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final snapshot = await FirebaseFirestore.instance
        .collection('eventTickets')
        .where('userId', isEqualTo: user.uid)
        .orderBy('purchaseDate', descending: true)
        .get();

    return snapshot.docs.map((doc) => EventTicketModel.fromFirestore(doc)).toList();
  }

  Future<Map<String, dynamic>> fetchEventDetails(String eventId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('event').doc(eventId).get();
      return doc.data() ?? {};
    } catch (_) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedType = 'hotel'),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedType == 'hotel' ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Hotels',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _selectedType == 'hotel' ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedType = 'event'),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedType == 'event' ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Events',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _selectedType == 'event' ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _selectedType == 'hotel'
                  ? _buildHotelBookingList(cardWidth)
                  : _buildEventTicketList(cardWidth),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelBookingList(double cardWidth) {
    return FutureBuilder<List<HotelBookingModel>>(
      future: fetchHotelBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary!),
                ),
                const SizedBox(height: 20),
                Text(
                  'Loading your stays...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  'Failed to load bookings',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please try again later',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        final bookings = snapshot.data ?? [];
        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  'No Hotel Bookings Yet',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Your upcoming hotel stays will appear here when you make a booking',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return FutureBuilder<Map<String, dynamic>>(
              future: fetchHotelDetails(booking.hotelId),
              builder: (context, detailsSnap) {
                final hotelName = detailsSnap.data?['name'] ?? 'Loading...';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _buildHotelCard(booking, hotelName, cardWidth, detailsSnap.data ?? {}),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEventTicketList(double cardWidth) {
    return FutureBuilder<List<EventTicketModel>>(
      future: fetchEventTickets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary!),
                ),
                const SizedBox(height: 20),
                Text(
                  'Loading your tickets...',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 183, 138),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  'Failed to load tickets',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please try again later',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        final tickets = snapshot.data ?? [];
        if (tickets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  'No Event Tickets Yet',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Your purchased event tickets will appear here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticket = tickets[index];
            return FutureBuilder<Map<String, dynamic>>(
              future: fetchEventDetails(ticket.eventId),
              builder: (context, detailsSnap) {
                final eventName = detailsSnap.data?['name'] ?? 'Loading...';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _buildEventCard(ticket, eventName, cardWidth, detailsSnap.data ?? {}),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildHotelCard(HotelBookingModel booking, String hotelName, double width, Map<String, dynamic> hotelDetails) {
    final nights = booking.checkOut.difference(booking.checkIn).inDays;
    final priceText = NumberFormat.currency(symbol: '₪').format(booking.price);
    final statusColor = booking.status == 'confirmed'
        ? Colors.green[700]!
        : booking.status == 'cancelled'
        ? Colors.red[700]!
        : AppColors.primary;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 222, 222, 222),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Icon(
                    Icons.hotel,
                    size: 60,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotelName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    Text(
                      '${booking.formattedCheckIn} - ${booking.formattedCheckOut}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const Spacer(),
                    Text(
                      '$nights night${nights > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Price',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          priceText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HotelDetailsPage(
                              hotel: hotelDetails,
                              hotelId: booking.hotelId,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepOrange[50],
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventTicketModel ticket, String eventName, double width, Map<String, dynamic> eventDetails) {
    final priceText = NumberFormat.currency(symbol: '₪').format(ticket.totalPrice);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 222, 222, 222),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Icon(
                    Icons.event,
                    size: 60,
                    color: Colors.grey[600], 
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    Text(
                      ticket.formattedPurchaseDate,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const Spacer(),
                    Text(
                      '${ticket.quantity} ticket${ticket.quantity > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Price',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          priceText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailsPage(
                              event: eventDetails,
                              eventId: ticket.eventId,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepOrange[50],
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:staypal/models/hotel_booking_model.dart';
// import 'package:staypal/models/event_ticket_model.dart';
// import 'package:staypal/screens/detailsPage/hotel/views/hotel_details_view.dart';
// import 'package:staypal/screens/detailsPage/event/views/event_details_view.dart';
// import 'package:staypal/constants/color_constants.dart';
// import 'package:staypal/screens/profile/viewmodels/my_bookings_viewmodel.dart';
//
// class MyBookingsScreen extends StatelessWidget {
//   const MyBookingsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => MyBookingsViewModel()..initialize(),
//       child: const MyBookingsView(),
//     );
//   }
// }
//
// class MyBookingsView extends StatelessWidget {
//   const MyBookingsView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final cardWidth = screenWidth * 0.9;
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           'My Bookings',
//           style: TextStyle(
//             color: Color.fromARGB(255, 0, 0, 0),
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//             letterSpacing: 0.5,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.primary,
//         elevation: 0,
//         toolbarHeight: 60,
//       ),
//       body: Consumer<MyBookingsViewModel>(
//         builder: (context, viewModel, child) {
//           return Column(
//             children: [
//               const SizedBox(height: 24),
//               _buildTypeSelector(context, viewModel),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: _buildBookingsList(context, viewModel, cardWidth),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTypeSelector(BuildContext context, MyBookingsViewModel viewModel) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 24),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.all(4),
//       child: Row(
//         children: [
//           Expanded(
//             child: InkWell(
//               onTap: () => viewModel.setSelectedType(BookingType.hotel),
//               borderRadius: BorderRadius.circular(8),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                   color: viewModel.selectedType == BookingType.hotel
//                       ? AppColors.primary
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Hotels',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: viewModel.selectedType == BookingType.hotel
//                           ? const Color.fromARGB(255, 0, 0, 0)
//                           : Colors.grey[700],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () => viewModel.setSelectedType(BookingType.event),
//               borderRadius: BorderRadius.circular(8),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                   color: viewModel.selectedType == BookingType.event
//                       ? AppColors.primary
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Events',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: viewModel.selectedType == BookingType.event
//                           ? const Color.fromARGB(255, 0, 0, 0)
//                           : Colors.grey[700],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBookingsList(BuildContext context, MyBookingsViewModel viewModel, double cardWidth) {
//     if (viewModel.isLoading) {
//       return _buildLoadingState(viewModel.selectedType);
//     }
//
//     if (viewModel.error != null) {
//       return _buildErrorState(viewModel.error!);
//     }
//
//     if (viewModel.selectedType == BookingType.hotel) {
//       return _buildHotelBookingsList(context, viewModel, cardWidth);
//     } else {
//       return _buildEventTicketsList(context, viewModel, cardWidth);
//     }
//   }
//
//   Widget _buildLoadingState(BookingType type) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary!),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             type == BookingType.hotel
//                 ? 'Loading your stays...'
//                 : 'Loading your tickets...',
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState(String error) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 48, color: AppColors.primary),
//           const SizedBox(height: 16),
//           Text(
//             'Failed to load bookings',
//             style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Please try again later',
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHotelBookingsList(BuildContext context, MyBookingsViewModel viewModel, double cardWidth) {
//     if (!viewModel.hasHotelBookings) {
//       return _buildEmptyState(
//         'No Hotel Bookings Yet',
//         'Your upcoming hotel stays will appear here when you make a booking',
//       );
//     }
//
//     return RefreshIndicator(
//       onRefresh: viewModel.refresh,
//       child: ListView.builder(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.only(bottom: 20),
//         itemCount: viewModel.hotelBookings.length,
//         itemBuilder: (context, index) {
//           final booking = viewModel.hotelBookings[index];
//           final hotelName = viewModel.getHotelName(booking.hotelId);
//           final hotelDetails = viewModel.getHotelDetails(booking.hotelId);
//           final referenceNumber = viewModel.generateHotelBookingReference(booking);
//
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: _buildHotelCard(
//               context,
//               booking,
//               hotelName,
//               cardWidth,
//               hotelDetails,
//               referenceNumber,
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildEventTicketsList(BuildContext context, MyBookingsViewModel viewModel, double cardWidth) {
//     if (!viewModel.hasEventTickets) {
//       return _buildEmptyState(
//         'No Event Tickets Yet',
//         'Your purchased event tickets will appear here',
//       );
//     }
//
//     return RefreshIndicator(
//       onRefresh: viewModel.refresh,
//       child: ListView.builder(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.only(bottom: 20),
//         itemCount: viewModel.eventTickets.length,
//         itemBuilder: (context, index) {
//           final ticket = viewModel.eventTickets[index];
//           final eventName = viewModel.getEventName(ticket.eventId);
//           final eventDetails = viewModel.getEventDetails(ticket.eventId);
//           final referenceNumber = viewModel.generateTicketReference(ticket);
//
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: _buildEventCard(
//               context,
//               ticket,
//               eventName,
//               cardWidth,
//               eventDetails,
//               referenceNumber,
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildEmptyState(String title, String subtitle) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 20),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 20,
//               color: Colors.grey[700],
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Text(
//               subtitle,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHotelCard(
//       BuildContext context,
//       HotelBookingModel booking,
//       String hotelName,
//       double width,
//       Map<String, dynamic> hotelDetails,
//       String referenceNumber,
//       ) {
//     final nights = booking.checkOut.difference(booking.checkIn).inDays;
//     final priceText = NumberFormat.currency(symbol: '₪').format(booking.price);
//     final statusColor = booking.status == 'confirmed'
//         ? Colors.green[700]!
//         : booking.status == 'cancelled'
//         ? Colors.red[700]!
//         : AppColors.primary;
//
//     return Container(
//       width: width,
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 222, 222, 222),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 2,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               Container(
//                 height: 120,
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                   color: Colors.grey[200],
//                 ),
//                 child: Center(
//                   child: Icon(
//                     Icons.hotel,
//                     size: 60,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 12,
//                 right: 12,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: statusColor,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     booking.status.toUpperCase(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   hotelName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Booking Ref: $referenceNumber',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
//                     const SizedBox(width: 8),
//                     Text(
//                       '${booking.formattedCheckIn} - ${booking.formattedCheckOut}',
//                       style: TextStyle(color: Colors.grey[700]),
//                     ),
//                     const Spacer(),
//                     Text(
//                       '$nights night${nights > 1 ? 's' : ''}',
//                       style: TextStyle(
//                         color: Colors.grey[700],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Total Price',
//                           style: TextStyle(
//                             color: Colors.grey[700],
//                             fontSize: 12,
//                           ),
//                         ),
//                         Text(
//                           priceText,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => HotelDetailsPage(
//                               hotel: hotelDetails,
//                               hotelId: booking.hotelId,
//                             ),
//                           ),
//                         );
//                       },
//                       style: TextButton.styleFrom(
//                         backgroundColor: Colors.deepOrange[50],
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Text(
//                         'View Details',
//                         style: TextStyle(
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEventCard(
//       BuildContext context,
//       EventTicketModel ticket,
//       String eventName,
//       double width,
//       Map<String, dynamic> eventDetails,
//       String referenceNumber,
//       ) {
//     final priceText = NumberFormat.currency(symbol: '₪').format(ticket.totalPrice);
//
//     return Container(
//       width: width,
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 222, 222, 222),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 2,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               Container(
//                 height: 120,
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                   color: Colors.grey[200],
//                 ),
//                 child: Center(
//                   child: Icon(
//                     Icons.event,
//                     size: 60,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   eventName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Ticket Ref: $referenceNumber',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
//                     const SizedBox(width: 8),
//                     Text(
//                       ticket.formattedPurchaseDate,
//                       style: TextStyle(color: Colors.grey[700]),
//                     ),
//                     const Spacer(),
//                     Text(
//                       '${ticket.quantity} ticket${ticket.quantity > 1 ? 's' : ''}',
//                       style: TextStyle(
//                         color: Colors.grey[700],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Total Price',
//                           style: TextStyle(
//                             color: Colors.grey[700],
//                             fontSize: 12,
//                           ),
//                         ),
//                         Text(
//                           priceText,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => EventDetailsPage(
//                               event: eventDetails,
//                               eventId: ticket.eventId,
//                             ),
//                           ),
//                         );
//                       },
//                       style: TextButton.styleFrom(
//                         backgroundColor: Colors.deepOrange[50],
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Text(
//                         'View Details',
//                         style: TextStyle(
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//}