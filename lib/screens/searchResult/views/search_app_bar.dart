import 'package:flutter/material.dart';
import 'package:staypal/screens/notification/notification_view.dart';
import 'package:staypal/screens/notification/notification_viewmodel.dart';
import 'package:staypal/screens/share/share_service.dart';
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
      title: viewModel.searchQuery != null && viewModel.searchQuery!.isNotEmpty
          ? Text('Results for "${viewModel.searchQuery}"',
              style: const TextStyle(color: Colors.black))
          : const Text('Hotels & Events', style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(
                      viewModel: NotificationViewModel(),
                    ),
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: NotificationViewModel(),
              builder: (context, _, __) {
                final unreadCount = NotificationViewModel().unreadCount;
                if (unreadCount > 0) {
                  return Positioned(
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
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.ios_share),
          onPressed: () {
            final query = viewModel.searchQuery;
            if (query != null && query.isNotEmpty) {
              ShareService.shareContent(
                title: query,
                deepLinkId: Uri.encodeComponent(query),
                type: 'search',
              );
            } else {
              ShareService.shareContent(
                title: 'Explore the best hotels and events!',
                deepLinkId: 'home',
                type: 'search',
              );
            }
          },
        ),
      ],
    );
  }
}