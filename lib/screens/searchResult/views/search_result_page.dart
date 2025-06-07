import 'package:flutter/material.dart';
import '../../homePage/widgets/custom_nav_bar.dart';
import '../viewmodels/search_result_view_model.dart';
import './search_app_bar.dart';
import './tab_buttons.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key}) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late SearchResultViewModel _viewModel;

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
      appBar: SearchAppBar(viewModel: _viewModel),
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
      body: Column(
        children: [
          TabButtons(
            viewModel: _viewModel,
            onTabChanged: () => setState(() {}),
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
}