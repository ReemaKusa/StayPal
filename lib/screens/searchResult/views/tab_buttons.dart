

import 'package:flutter/material.dart';
import '../viewmodels/search_result_view_model.dart';
import 'tab_button.dart';

class TabButtons extends StatelessWidget {
  final SearchResultViewModel viewModel;
  final VoidCallback onTabChanged;

  const TabButtons({
    Key? key,
    required this.viewModel,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TabButton(
            label: 'Hotels',
            active: viewModel.showHotels,
            onPressed: () {
              viewModel.showHotels = true;
              onTabChanged();
            },
          ),
          const SizedBox(width: 12),
          TabButton(
            label: 'Events',
            active: !viewModel.showHotels,
            onPressed: () {
              viewModel.showHotels = false;
              onTabChanged();
            },
          ),
        ],
      ),
    );
  }
}