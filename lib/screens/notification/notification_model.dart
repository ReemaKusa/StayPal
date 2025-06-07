class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String formattedDate;
  final bool isRead;
  final String? imageUrl;
  final String? actionRoute;
  final String type; // 'like' or 'booking'

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.formattedDate,
    this.isRead = false,
    this.imageUrl,
    this.actionRoute,
    required this.type,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? formattedDate,
    bool? isRead,
    String? imageUrl,
    String? actionRoute,
    String? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      formattedDate: formattedDate ?? this.formattedDate,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      actionRoute: actionRoute ?? this.actionRoute,
      type: type ?? this.type,
    );
  }
}