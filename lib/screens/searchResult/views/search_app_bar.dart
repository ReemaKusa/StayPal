
import 'package:flutter/material.dart';
import '../viewmodels/search_result_view_model.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SearchResultViewModel viewModel;

  const SearchAppBar({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: viewModel.searchQuery != null
          ? Text('Results for "${viewModel.searchQuery}"')
          : const Text('Hotels & Events'),
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: true,
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
    );
  }
}