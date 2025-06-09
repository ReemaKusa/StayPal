
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';

class SearchField extends StatelessWidget {
  final bool isWeb;
  final Function(BuildContext) onPerformSearch;

  const SearchField({
    super.key,
    this.isWeb = false,
    required this.onPerformSearch,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: viewModel.searchController,
              decoration: InputDecoration(
                hintText: isWeb
                    ? "Search for hotels, events, or locations..."
                    : "Search for hotels, events, or locations",
                border: InputBorder.none,
              ),
              onChanged: (value) => viewModel.updateSearchQuery(value),
              onSubmitted: (_) => onPerformSearch(context),
            ),
          ),
          if (viewModel.searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: viewModel.clearSearch,
            ),
        ],
      ),
    );
  }
}