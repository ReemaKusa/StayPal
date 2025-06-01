import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../search_result/event/views/event_details_view.dart';
import '../../search_result/hotel/views/hotel_details_view.dart';
import '../../homePageTwo/widgets/custom_nav_bar.dart';
import '../viewmodels/search_result_view_model.dart';
import 'package:provider/provider.dart'; 


class SearchResultPage extends StatefulWidget {
  final GlobalKey _searchKey = GlobalKey();
  SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  @override
  Widget build(BuildContext context) {
    // Get arguments from navigation
    final args = ModalRoute.of(context)?.settings.arguments as dynamic ?; /////////////////////////////// was Map
    final searchQuery = args?['searchQuery'];
    final filterBy = args?['filterBy'];

    // Initialize viewModel
    final viewModel = SearchResultViewModel()
      ..searchQuery = searchQuery
      ..filterBy = filterBy;
    viewModel.initializeLikes(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavBar(
        currentIndex: 0,
        searchKey: widget._searchKey,
      ),
      appBar: AppBar(
        title: viewModel.searchQuery != null
            ? Text('Results for "${viewModel.searchQuery}"')
            : const Text('Hotels & Events'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
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
            key: widget._searchKey,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tabButton(
                  'Hotels', 
                  viewModel.showHotels, 
                  () => setState(() => viewModel.showHotels = true)
                ),
                const SizedBox(width: 12),
                _tabButton(
                  'Events', 
                  !viewModel.showHotels, 
                  () => setState(() => viewModel.showHotels = false)
                ),
              ],
            ),
          ),
          Expanded(
            child: viewModel.showHotels
                ? viewModel.buildHotelList(context)
                : viewModel.buildEventList(context),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String label, bool active, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? Colors.orange : Colors.orange.shade200,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }
}
