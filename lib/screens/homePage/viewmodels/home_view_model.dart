import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/popular_hotels_model.dart';
import '../models/recommended_item_model.dart';
import '../models/upcoming_events_model.dart';

class HomeViewModel with ChangeNotifier {
  List<UpcomingEventsModel> upcomingEvents = [];
  List<PopularHotelsModel> popularHotels = [];
  List<RecommendedItemModel> recommendedItems = [];
  bool isLoading = true;
  String searchQuery = '';

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void updateSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery = '';
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      final eventsQuery = await FirebaseFirestore.instance.collection('upcomingEvents').get();
      final hotelsQuery = await FirebaseFirestore.instance.collection('popularHotels').get();
      final recommendedQuery = await FirebaseFirestore.instance.collection('recommendedItems').get();

      upcomingEvents = eventsQuery.docs
          .map((doc) => UpcomingEventsModel.fromMap(doc.id, doc.data()))
          .toList();
      
      popularHotels = hotelsQuery.docs
          .map((doc) => PopularHotelsModel.fromMap(doc.id, doc.data()))
          .toList();
      
      recommendedItems = recommendedQuery.docs
          .map((doc) => RecommendedItemModel.fromMap(doc.id, doc.data()))
          .toList();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching data: $e");
      isLoading = false;
      notifyListeners();
    }
  }
}