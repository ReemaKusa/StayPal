import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';
import './header.dart';
import './search_field.dart';
import './upcoming_events_section.dart';
import './popular_hotels_section.dart';
import './recommended_section.dart';
//import '../../search_result/hotel/views/hotel_details_view.dart';
//import '../../search_result/event/views/event_details_view.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/webNavBar/web_nav_bar.dart';

class HomePage extends StatelessWidget {
  final GlobalKey searchKey = GlobalKey();

  void _scrollToSearch(BuildContext context) {
    if (searchKey.currentContext != null) {
      Scrollable.ensureVisible(
        searchKey.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _performSearch(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    final query = viewModel.searchQuery.trim();
    if (query.isEmpty) return;

    Navigator.pushNamed(
      context,
      '/searchresult',
      arguments: {'searchQuery': query},
    );
    viewModel.clearSearch();
  }

  Widget _buildSearchButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _performSearch(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Search'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return ChangeNotifierProvider(
      create: (context) => HomeViewModel()..fetchData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: isWeb
            ? null
            : Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  return CustomNavBar(
                    currentIndex: 0,
                    searchKey: searchKey,
                    onSearchPressed: () => _scrollToSearch(context),
                  );
                },
              ),
        appBar: isWeb ? WebNavBar(currentIndex: 0) : null,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(isWeb ? 24 : 16),
            child: Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  controller: viewModel.scrollController,
                  child: isWeb
                      ? _buildWebLayout(context, viewModel)
                      : _buildMobileLayout(context, viewModel),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeHeader(),
        const SizedBox(height: 16),
        SearchField(
          key: searchKey,
          onPerformSearch: _performSearch,
        ),
        if (viewModel.searchQuery.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildSearchButton(context),
        ],
        const SizedBox(height: 24),
        const UpcomingEventsSection(),
        const SizedBox(height: 28),
        const PopularHotelsSection(),
        const SizedBox(height: 30),
        const RecommendedSection(),
      ],
    );
  }

  Widget _buildWebLayout(BuildContext context, HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeHeader(isWeb: true),
        const SizedBox(height: 24),
        SearchField(
          key: searchKey,
          isWeb: true,
          onPerformSearch: _performSearch,
        ),
        if (viewModel.searchQuery.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildSearchButton(context),
        ],
        const SizedBox(height: 32),
        const UpcomingEventsSection(isWeb: true),
        const SizedBox(height: 40),
        const PopularHotelsSection(isWeb: true),
        const SizedBox(height: 40),
        const RecommendedSection(isWeb: true),
      ],
    );
  }
}