import 'package:flutter/material.dart';
import '../../../widgets/custom_nav_bar.dart';
import '../viewmodels/search_result_view_model.dart';
import './search_app_bar.dart';
import './tab_buttons.dart';
import 'package:staypal/screens/searchResult/viewmodels/event_list.dart';
import 'package:staypal/screens/searchResult/viewmodels/hotel_list.dart';


class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key}) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late SearchResultViewModel _viewModel;
  final String currentUserId = 'user123'; // Replace with actual user ID

  @override
  void initState() {
    super.initState();
    _viewModel = SearchResultViewModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel.initializeFromRouteArgs(context);
    _viewModel.initializeLikes(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SearchAppBar(
        viewModel: _viewModel,
        currentUserId: currentUserId,
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
      body: Column(
        children: [
          TabButtons(
            viewModel: _viewModel,
            onTabChanged: () => setState(() {}),
          ),
          Expanded(
            child: _viewModel.showHotels
                ? HotelList(
                    viewModel: _viewModel,
                    currentUserId: currentUserId,
                  )
                : EventList(
                    viewModel: _viewModel,
                    currentUserId: currentUserId,
                  ),
          ),
        ],
      ),
    );
  }
}