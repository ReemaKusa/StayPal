import 'package:flutter/material.dart';
import 'package:staypal/screens/notification/notification_view.dart';
import 'package:staypal/screens/notification/notification_viewmodel.dart';
import 'package:staypal/screens/notification/notification_model.dart';

import 'package:staypal/screens/share/share_service.dart';
import '../viewmodels/search_result_view_model.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SearchResultViewModel viewModel;
  final String currentUserId;

  const SearchAppBar({
    Key? key,
    required this.viewModel,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final notificationViewModel = NotificationViewModel();
    
    return AppBar(
      title: viewModel.searchQuery != null && viewModel.searchQuery!.isNotEmpty
          ? Text('Results for "${viewModel.searchQuery}"',
              style: const TextStyle(color: Colors.black))
          : const Text('Hotels & Events', style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        StreamBuilder<List<NotificationModel>>(
          stream: notificationViewModel.getNotifications(currentUserId),
          builder: (context, snapshot) {
            final unreadCount = snapshot.data?.where((n) => !n.isRead).length ?? 0;
            
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(
                          userId: currentUserId,
                          viewModel: notificationViewModel,
                        ),
                      ),
                    );
                  },
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Center(
                        child: Text(
                          unreadCount > 9 ? '9+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.ios_share),
          onPressed: () async {
            final query = viewModel.searchQuery ?? 'All';
            final isHotels = viewModel.showHotels;
            final items = isHotels 
                ? viewModel.getHotelsAsMapList()
                : viewModel.getEventsAsMapList();

            await ShareService.shareSearchResults(
              isHotels: isHotels,
              items: items,
              searchQuery: query,
            );
          },
        ),
      ],
    );
  }
}