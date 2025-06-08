import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'notification_model.dart';
import 'notification_viewmodel.dart';

class NotificationScreen extends StatelessWidget {
  final String userId;
  final NotificationViewModel viewModel;

  const NotificationScreen({
    super.key,
    required this.userId,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('NOTIFICATIONS',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.checkDouble, size: 20),
            onPressed: () => viewModel.markAllAsRead(userId),
            tooltip: 'Mark all as read',
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.trashAlt, size: 20),
            onPressed: () => viewModel.clearAll(userId),
            tooltip: 'Clear all',
          ),
        ],
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: viewModel.getNotifications(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }

          final notifications = snapshot.data!;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(FontAwesomeIcons.bellSlash,
                      size: 60, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text('NO NOTIFICATIONS YET',
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                          letterSpacing: 1.2)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return _NotificationCard(
                notification: notifications[index],
                onTap: () => _handleNotificationTap(
                    context, userId, notifications[index], viewModel),
              );
            },
          );
        },
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, String userId,
      NotificationModel notification, NotificationViewModel viewModel) {
    if (!notification.isRead) {
      viewModel.markAsRead(userId, notification.id);
    }

    if (notification.actionRoute != null) {
      Navigator.pushNamed(context, notification.actionRoute!);
    }
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : const Color(0xFFE3F2FD), // Baby blue light
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.targetName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (notification.type == 'like')
                        const FaIcon(FontAwesomeIcons.solidHeart,
                            size: 16, color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.title.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        notification.formattedDate,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: notification.isRead ? Colors.grey : Colors.blueAccent,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: notification.firstImageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: notification.firstImageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: Colors.grey[300]),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.hotel, color: Colors.grey),
              )
            : const Icon(Icons.hotel, color: Colors.grey),
      ),
    );
  }
}
