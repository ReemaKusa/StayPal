import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_model.dart';

class NotificationViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  Stream<List<NotificationModel>> getNotifications(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      _notifications = snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
      _unreadCount = _notifications.where((n) => !n.isRead).length;
      notifyListeners();
      return _notifications;
    });
  }

  Future<void> addNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    List<String> imageUrls = const [],
    String? actionRoute,
    required String targetName,
    required String targetId,
  }) async {
    final existing = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('type', isEqualTo: type)
        .where('targetId', isEqualTo: targetId)
        .get();

    if (existing.docs.isEmpty) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add({
        'title': title,
        'message': message,
        'isRead': false,
        'imageUrls': imageUrls,
        'actionRoute': actionRoute,
        'type': type,
        'targetName': targetName,
        'targetId': targetId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _unreadCount++;
      notifyListeners();
    }
  }

  Future<void> removeLikeNotification(String userId, String targetId) async {
    try {
      final query = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .where('type', isEqualTo: 'like')
          .where('targetId', isEqualTo: targetId)
          .get();

      final batch = _firestore.batch();
      for (final doc in query.docs) {
        batch.delete(doc.reference);
        if (!(doc.data()['isRead'] ?? false)) {
          _unreadCount--;
        }
      }
      await batch.commit();
      
      _notifications.removeWhere((n) => n.type == 'like' && n.targetId == targetId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing like notification: $e');
      rethrow;
    }
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
    _unreadCount--;
    notifyListeners();
  }

  Future<void> markAllAsRead(String userId) async {
    final query = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in query.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
    _unreadCount = 0;
    notifyListeners();
  }

  Future<void> clearAll(String userId) async {
    final query = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .get();

    final batch = _firestore.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }
}