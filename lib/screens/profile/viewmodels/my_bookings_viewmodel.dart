// import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:staypal/models/hotel_booking_model.dart';
// import 'package:staypal/models/event_ticket_model.dart';
//
// enum BookingType { hotel, event }
//
// class MyBookingsViewModel extends ChangeNotifier {
//   BookingType _selectedType = BookingType.hotel;
//   List<HotelBookingModel> _hotelBookings = [];
//   List<EventTicketModel> _eventTickets = [];
//   Map<String, Map<String, dynamic>> _hotelDetailsCache = {};
//   Map<String, Map<String, dynamic>> _eventDetailsCache = {};
//   Map<HotelBookingModel, String> _hotelBookingIds = {};
//   Map<EventTicketModel, String> _eventTicketIds = {};
//   bool _isLoading = false;
//   String? _error;
//
//   BookingType get selectedType => _selectedType;
//   List<HotelBookingModel> get hotelBookings => _hotelBookings;
//   List<EventTicketModel> get eventTickets => _eventTickets;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get hasHotelBookings => _hotelBookings.isNotEmpty;
//   bool get hasEventTickets => _eventTickets.isNotEmpty;
//
//   void setSelectedType(BookingType type) {
//     if (_selectedType != type) {
//       _selectedType = type;
//       notifyListeners();
//       loadBookings();
//     }
//   }
//
//   Future<void> initialize() async {
//     await loadBookings();
//   }
//
//   // Load bookings based on selected type
//   Future<void> loadBookings() async {
//     _setLoading(true);
//     _setError(null);
//
//     try {
//       if (_selectedType == BookingType.hotel) {
//         await _loadHotelBookings();
//       } else {
//         await _loadEventTickets();
//       }
//     } catch (e) {
//       _setError('Failed to load bookings: ${e.toString()}');
//     } finally {
//       _setLoading(false);
//     }
//   }
//
//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }
//
//   void _setError(String? error) {
//     _error = error;
//     notifyListeners();
//   }
//
//   Future<void> _loadHotelBookings() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception('User not logged in');
//
//     final snapshot = await FirebaseFirestore.instance
//         .collection('hotel_bookings')
//         .where('userId', isEqualTo: user.uid)
//         .orderBy('createdAt', descending: true)
//         .get();
//
//     _hotelBookings = snapshot.docs
//         .map((doc) {
//       final booking = HotelBookingModel.fromFirestore(doc);
//       _hotelBookingIds[booking] = doc.id;
//       return booking;
//     })
//         .toList();
//
//     for (final booking in _hotelBookings) {
//       if (!_hotelDetailsCache.containsKey(booking.hotelId)) {
//         final details = await _fetchHotelDetails(booking.hotelId);
//         _hotelDetailsCache[booking.hotelId] = details;
//       }
//     }
//
//     notifyListeners();
//   }
//
//   Future<void> _loadEventTickets() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception('User not logged in');
//
//     final snapshot = await FirebaseFirestore.instance
//         .collection('eventTickets')
//         .where('userId', isEqualTo: user.uid)
//         .orderBy('purchaseDate', descending: true)
//         .get();
//
//     _eventTickets = snapshot.docs
//         .map((doc) {
//       final ticket = EventTicketModel.fromFirestore(doc);
//       _eventTicketIds[ticket] = doc.id;
//       return ticket;
//     })
//         .toList();
//
//     for (final ticket in _eventTickets) {
//       if (!_eventDetailsCache.containsKey(ticket.eventId)) {
//         final details = await _fetchEventDetails(ticket.eventId);
//         _eventDetailsCache[ticket.eventId] = details;
//       }
//     }
//
//     notifyListeners();
//   }
//
//   Future<Map<String, dynamic>> _fetchHotelDetails(String hotelId) async {
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('hotel')
//           .doc(hotelId)
//           .get();
//       return doc.data() ?? {};
//     } catch (_) {
//       return {};
//     }
//   }
//
//   Future<Map<String, dynamic>> _fetchEventDetails(String eventId) async {
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('event')
//           .doc(eventId)
//           .get();
//       return doc.data() ?? {};
//     } catch (_) {
//       return {};
//     }
//   }
//
//   Map<String, dynamic> getHotelDetails(String hotelId) {
//     return _hotelDetailsCache[hotelId] ?? {};
//   }
//
//   Map<String, dynamic> getEventDetails(String eventId) {
//     return _eventDetailsCache[eventId] ?? {};
//   }
//
//   String getHotelName(String hotelId) {
//     final details = getHotelDetails(hotelId);
//     return details['name'] ?? 'Unknown Hotel';
//   }
//
//   String getEventName(String eventId) {
//     final details = getEventDetails(eventId);
//     return details['name'] ?? 'Unknown Event';
//   }
//
//   String generateHotelBookingReference(HotelBookingModel booking) {
//     final docId = _hotelBookingIds[booking];
//     if (docId != null) {
//       final shortId = docId.substring(0, 6).toUpperCase();
//       final timestamp = booking.createdAt.millisecondsSinceEpoch;
//       return 'HTL-$shortId-${timestamp.toString().substring(7)}';
//     }
//
//     final timestamp = booking.createdAt.millisecondsSinceEpoch;
//     final shortTimestamp = timestamp.toString().substring(7);
//     return 'HTL-${shortTimestamp.substring(0, 6).toUpperCase()}-$shortTimestamp';
//   }
//
//   String generateTicketReference(EventTicketModel ticket) {
//
//     final docId = _eventTicketIds[ticket];
//     if (docId != null) {
//       final shortId = docId.substring(0, 6).toUpperCase();
//       final timestamp = ticket.purchaseDate.millisecondsSinceEpoch;
//       return 'EVT-$shortId-${timestamp.toString().substring(7)}';
//     }
//
//     final timestamp = ticket.purchaseDate.millisecondsSinceEpoch;
//     final shortTimestamp = timestamp.toString().substring(7);
//     return 'EVT-${shortTimestamp.substring(0, 6).toUpperCase()}-$shortTimestamp';
//   }
//
//   Future<void> refresh() async {
//     _hotelDetailsCache.clear();
//     _eventDetailsCache.clear();
//     _hotelBookingIds.clear();
//     _eventTicketIds.clear();
//     await loadBookings();
//   }
// }