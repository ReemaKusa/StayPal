import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final List<String> imageUrls;
  final String? actionRoute;
  final String type;
  final String targetName;
  final String targetId;
  final DateTime timestamp;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.imageUrls,
    this.actionRoute,
    required this.type,
    required this.targetName,
    required this.targetId,
    required this.timestamp,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? 'New Notification',
      message: data['message'] ?? '',
      isRead: data['isRead'] ?? false,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      actionRoute: data['actionRoute'],
      type: data['type'] ?? 'general',
      targetName: data['targetName'] ?? 'Unknown',
      targetId: data['targetId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return DateFormat('MMM d, y').format(timestamp);
  }

  String get firstImageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';
}