import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../search_result/event/views/event_details_view.dart';
import '../../search_result/hotel/views/hotel_details_view.dart';
import '../../homePageTwo/widgets/custom_nav_bar.dart';
import '../viewmodels/search_result_view_model.dart';

class SearchResultPage extends StatefulWidget {
  final GlobalKey _searchKey = GlobalKey();
  SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late SearchResultViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SearchResultViewModel();
    _viewModel.initializeLikes(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (_viewModel.searchQuery == null && routeArgs is Map<String, dynamic>) {
      _viewModel.searchQuery = routeArgs['searchQuery'] as String?;
      _viewModel.filterBy = routeArgs['filterBy'] as String?;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavBar(
        currentIndex: 0,
        searchKey: widget._searchKey,
      ),
      appBar: AppBar(
        title: _viewModel.searchQuery != null
            ? Text('Results for "${_viewModel.searchQuery}"')
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _tabText("Hotels", _viewModel.showHotels, () {
                    setState(() => _viewModel.showHotels = true);
                  }),
                  _tabText("Events", !_viewModel.showHotels, () {
                    setState(() => _viewModel.showHotels = false);
                  }),
                ],
              ),
            ),
          ),
          Expanded(
            child: _viewModel.showHotels
                ? _viewModel.buildHotelList(context)
                : _viewModel.buildEventList(context),
          ),
        ],
      ),
    );
  }

  Widget _tabText(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.orange : Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
