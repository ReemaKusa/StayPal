import 'package:flutter/material.dart';
import 'notification_model.dart';
import 'notification_viewmodel.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationViewModel viewModel;
  final Function(String)? onNotificationTap;

  const NotificationScreen({
    super.key,
    required this.viewModel,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Notifications'),
            if (viewModel.unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  viewModel.unreadCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: viewModel.markAllAsRead,
            tooltip: 'Mark all as read',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: viewModel.clearAll,
            tooltip: 'Clear all',
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: viewModel,
        builder: (context, _, __) {
          if (viewModel.notifications.isEmpty) {
            return const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: viewModel.notifications.length,
            itemBuilder: (context, index) {
              final notification = viewModel.notifications[index];
              return NotificationCard(
                notification: notification,
                onTap: () {
                  viewModel.markAsRead(notification.id);
                  if (onNotificationTap != null) {
                    onNotificationTap!(notification.actionRoute ?? '');
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      color: notification.isRead ? Colors.grey[100] : Colors.blue[50],
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                notification.type == 'like' ? Icons.favorite : Icons.confirmation_num,
                color: notification.type == 'like' ? Colors.red : Colors.green,
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(left: 8, top: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}