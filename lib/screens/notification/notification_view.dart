import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:staypal/screens/detailsPage/event/views/event_details_view.dart';
import 'package:staypal/screens/detailsPage/hotel/views/hotel_details_view.dart';
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
        title: const Text('Notifications',
            style: TextStyle(
              fontSize: 16, // تصغير حجم الخط
              fontWeight: FontWeight.normal, // إزالة التغبيق
              letterSpacing: 1.0,
              color: Colors.black, // تغيير لون الخط إلى الأسود
            )),
        backgroundColor: Colors.white, // تغيير لون الخلفية إلى الأبيض
        elevation: 1, // إضافة ظل خفيف
        iconTheme: const IconThemeData(color: Colors.black), // أيقونات سوداء
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.checkDouble, 
                size: 20, 
                color: Colors.black), // أيقونة سوداء
            onPressed: () => viewModel.markAllAsRead(userId),
            tooltip: 'Mark all as read',
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.trashAlt, 
                size: 20, 
                color: Colors.black), // أيقونة سوداء
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
                  Text('No notifications yet',
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16, // تصغير حجم الخط
                          fontWeight: FontWeight.normal, // إزالة التغبيق
                          letterSpacing: 1.0)),
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
                userId: userId,
                viewModel: viewModel,
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final String userId;
  final NotificationViewModel viewModel;

  const _NotificationCard({
    required this.notification,
    required this.userId,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : const Color(0xFFE3F2FD),
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
                          fontSize: 14, // تصغير حجم الخط
                          fontWeight: FontWeight.normal, // إزالة التغبيق
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (notification.type == 'like')
                      const FaIcon(FontAwesomeIcons.solidHeart,
                          size: 16, color: Colors.black), // أيقونة سوداء
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.title,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.normal, // إزالة التغبيق
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.message,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13, // تصغير حجم الخط قليلاً
                    fontWeight: FontWeight.normal, // إزالة التغبيق
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.formattedDate,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11, // تصغير حجم الخط
                    fontWeight: FontWeight.normal, // إزالة التغبيق
                  ),
                ),
              ],
            ),
          ),
        ],
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
          color: notification.isRead ? Colors.grey : Colors.black, // تغيير اللون إلى الأسود
          width: 2,
        ),
      ),
      child: ClipOval(
        child: notification.firstImageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: notification.firstImageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey[300]),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.hotel, color: Colors.grey),
              )
            : const Icon(Icons.hotel, color: Colors.grey),
      ),
    );
  }
}