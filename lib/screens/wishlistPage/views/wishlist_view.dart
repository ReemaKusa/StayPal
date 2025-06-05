import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:intl/intl.dart';
// import '../../search_result/hotel/views/hotel_details_view.dart';
// import '../../search_result/event/views/event_details_view.dart';
import '../../homePage/widgets/custom_nav_bar.dart';
import '../viewmodels/wishlist_view_model.dart';
import './empty_wishlist.dart';
import './wishlist_items_list.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  final WishListViewModel _viewModel = WishListViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomNavBar(currentIndex: 2),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'My Wishlist',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      centerTitle: false,
      iconTheme: const IconThemeData(color: Colors.black),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pushNamed(context, '/home'),
      ),
      actions: [_buildNotificationIcon()],
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: _viewModel.wishlistStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data ?? [];
        if (docs.isEmpty) {
          return const EmptyWishlistPlaceholder();
        }

        return WishlistItemsList(docs: docs, viewModel: _viewModel);
      },
    );
  }

  Widget _buildNotificationIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 28),
            onPressed: () {},
          ),
          const Positioned(
            right: 10,
            top: 10,
            child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}