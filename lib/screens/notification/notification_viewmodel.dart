import 'package:flutter/material.dart';
import 'notification_model.dart';

class NotificationViewModel extends ValueNotifier<void> {
  List<NotificationModel> _notifications = [];

  NotificationViewModel() : super(null);

  List<NotificationModel> get notifications => _notifications;

  void addNotification(NotificationModel notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
