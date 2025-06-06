import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/review_view_model.dart';
import './rating_summary_widget.dart';
import './review_item_widget.dart';
import './empty_reviews_widget.dart';
import './leave_review_tab.dart';
import './search_header_delegate.dart';
import '../../../models/review_model.dart';

class FeedbackScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;

  const FeedbackScreen({
    Key? key,
    required this.serviceId,
    required this.serviceName,
  }) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedbackViewModel()
        ..initialize(widget.serviceId, widget.serviceName),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                title: Text('${widget.serviceName} Reviews'),
                pinned: true,
                floating: true,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.deepOrange,
                  labelColor: Colors.deepOrange,
                  unselectedLabelColor:
                      Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                  tabs: const [
                    Tab(text: 'Reviews', icon: Icon(Icons.reviews)),
                    Tab(text: 'Write Review', icon: Icon(Icons.edit)),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildReviewsTab(),
              _buildLeaveReviewTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Consumer<FeedbackViewModel>(
      builder: (context, viewModel, _) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: RatingSummaryWidget(stats: viewModel.ratingStats),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchHeaderDelegate(
                onSearchChanged: (query) => viewModel.searchQuery = query,
              ),
            ),
            StreamBuilder<List<Review>>(
              stream: viewModel.getReviewsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Error loading reviews: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                final reviews = snapshot.data ?? [];
                if (reviews.isEmpty) {
                  return SliverToBoxAdapter(
                    child: EmptyReviewsWidget(isSearchResult: false),
                  );
                }

                final filteredReviews = viewModel.filterReviews(reviews, viewModel.searchQuery);
                if (filteredReviews.isEmpty) {
                  return SliverToBoxAdapter(
                    child: EmptyReviewsWidget(isSearchResult: true),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ReviewItemWidget(review: filteredReviews[index]),
                    childCount: filteredReviews.length,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLeaveReviewTab() {
    return LeaveReviewTab(
      serviceName: widget.serviceName,
      onReviewSubmitted: () => _tabController.animateTo(0),
    );
  }

}