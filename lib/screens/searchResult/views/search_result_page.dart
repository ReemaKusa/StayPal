import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../search_result/event/views/event_details_view.dart';
import '../../search_result/hotel/views/hotel_details_view.dart';
import '../../homePage/widgets/custom_nav_bar.dart';
import '../viewmodels/search_result_view_model.dart';
import 'package:provider/provider.dart';


class SearchResultPage extends StatefulWidget {
  SearchResultPage({Key? key}) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late SearchResultViewModel _viewModel;

  final GlobalKey _searchKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _viewModel = SearchResultViewModel();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is Map<String, dynamic>) {
      _viewModel.searchQuery = routeArgs['searchQuery'] as String?;
      _viewModel.filterBy = routeArgs['filterBy'] as String?;
      _viewModel.isNumericSearch = routeArgs['isNumeric'] ?? false;
    }
    _viewModel.initializeLikes(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
      bottomNavigationBar: CustomNavBar(currentIndex: 1),
      body: Column(
        children: [
          Padding(
            key: _searchKey,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tabButton(
                  'Hotels',
                  _viewModel.showHotels,
                  () => setState(() => _viewModel.showHotels = true),
                ),
                const SizedBox(width: 12),
                _tabButton(
                  'Events',
                  !_viewModel.showHotels,
                  () => setState(() => _viewModel.showHotels = false),
                ),
              ],
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

  Widget _tabButton(String label, bool active, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: active
            ? const Color.fromARGB(255, 255, 94, 0)
            : Colors.orange.shade200,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Text(label),
    );

  }


}