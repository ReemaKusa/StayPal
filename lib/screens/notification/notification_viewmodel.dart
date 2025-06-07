import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notification_model.dart';

class NotificationViewModel extends ValueNotifier<void> {
  static final NotificationViewModel _instance = NotificationViewModel._internal();
  
  factory NotificationViewModel() {
    return _instance;
  }
  
  NotificationViewModel._internal() : super(null);
  
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  void addNotification({
    required String title,
    required String message,
    String? imageUrl,
    String? actionRoute,
    required String type,
  }) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      formattedDate: _formatDate(DateTime.now()),
      isRead: false,
      imageUrl: imageUrl,
      actionRoute: actionRoute,
      type: type,
    );
    
    _notifications.insert(0, notification);
    _unreadCount++;
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _unreadCount--;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _unreadCount = 0;
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    
    return DateFormat('MMM d, y').format(date);
  }
}