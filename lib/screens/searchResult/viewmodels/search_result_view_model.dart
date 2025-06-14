import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './like_manager.dart';

class SearchResultViewModel with LikeManager {
  bool showHotels = true;
  String? searchQuery;
  String? filterBy;
  bool isNumericSearch = false;

  final CollectionReference hotelsCollection =
      FirebaseFirestore.instance.collection('hotel');

  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('event');

  final CollectionReference wishlistCollection =
      FirebaseFirestore.instance.collection('wishlist_testing');

  final Map<String, bool> _hotelLikes = {};
  final Map<String, bool> _eventLikes = {};

  List<Map<String, dynamic>> hotelResults = [];
  List<Map<String, dynamic>> eventResults = [];

  Future<void> initializeLikes(BuildContext context) async {
    try {
      final snapshot = await wishlistCollection.get();
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final type = data['type'] as String?;
        if (type == 'hotel') _hotelLikes[doc.id] = true;
        if (type == 'event') _eventLikes[doc.id] = true;
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading favorites')),
      );
    }
  }

  void initializeFromRouteArgs(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is Map<String, dynamic>) {
      searchQuery = routeArgs['searchQuery'] as String?;
      filterBy = routeArgs['filterBy'] as String?;
      isNumericSearch = routeArgs['isNumeric'] ?? false;
    }
  }

  List<Map<String, dynamic>> getHotelsAsMapList() => hotelResults;
  List<Map<String, dynamic>> getEventsAsMapList() => eventResults;

  void setHotelResults(List<Map<String, dynamic>> hotels) {
    hotelResults = hotels;
  }

  void setEventResults(List<Map<String, dynamic>> events) {
    eventResults = events;
  }
}