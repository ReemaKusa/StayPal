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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  viewModel.showHotels = true;
                  onTabChanged();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: viewModel.showHotels ? Colors.white : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Hotels',
                      style: TextStyle(
                        color: viewModel.showHotels ? Colors.orange : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  viewModel.showHotels = false;
                  onTabChanged();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: !viewModel.showHotels ? Colors.white : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Events',
                      style: TextStyle(
                        color: !viewModel.showHotels ? Colors.orange : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}