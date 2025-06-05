import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String eventId;
  final Map<String, dynamic> event;

  EventModel({
    required this.eventId,
    required this.event,
  });

  String get name => event['name']?.toString() ?? 'No Name';
  String get location => event['location']?.toString() ?? 'No Location';
  String get description => event['description']?.toString() ?? 'No Description';
  String get details => event['details']?.toString() ?? 'No Details';

  double get price {
    final raw = event['price'];
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw) ?? 0.0;
    return 0.0;
  }

  String get time => event['time']?.toString() ?? 'No Time';
  String get organizerId => event['organizerId'] ?? '';

  DateTime? get date {
    final raw = event['date'];
    if (raw is Timestamp) return raw.toDate();
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  List<String> get highlights {
    if (event['highlights'] is List) {
      return List<String>.from(event['highlights'].whereType<String>());
    }
    return [];
  }

  List<String> get images {
    if (event['images'] is List) {
      return List<String>.from(event['images'].whereType<String>());
    }
    return [];
  }

  bool get isFavorite => event['isFavorite'] ?? false;

  double get rating => (event['rating'] as num?)?.toDouble() ?? 0.0;
  String get formattedRating => rating > 0 ? '$rating ★' : 'No Rating';

  String get formattedPrice => '${price.toStringAsFixed(2)} ₪';

  factory EventModel.fromDocument(DocumentSnapshot doc) {
    return EventModel(
      eventId: doc.id,
      event: doc.data() as Map<String, dynamic>,
    );
  }
}