import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailsModel {
  final String eventId;
  final Map<String, dynamic> event;

  EventDetailsModel({
    required this.eventId,
    required this.event,
  });

  String get name => event['name']?.toString() ?? 'No Name';
  String get location => event['location']?.toString() ?? 'No Location';
  String get description => event['description']?.toString() ?? 'No Description';
  String get details => event['details']?.toString() ?? 'No Details';
  
  List<String> get images {
    if (event['images'] is List) {
      return List<String>.from(event['images'].whereType<String>());
    }
    return [];
  }

  double get price => (event['price'] as num?)?.toDouble() ?? 0.0;
  String get formattedPrice => '${price.toStringAsFixed(2)} ₪';
  
  List<String> get highlights {
    if (event['highlights'] is List) {
      return List<String>.from(event['highlights'].whereType<String>());
    }
    return [];
  }

  Timestamp? get date => event['date'] is Timestamp ? event['date'] : null;
  
  String get formattedTime {
    if (event['time'] is num) {
      final hours = (event['time'] as num).toInt();
      final minutes = ((event['time'] as num) - hours) * 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toInt().toString().padLeft(2, '0')}';
    }
    return 'No Time';
  }

  bool get isFavorite => event['isFavorite'] == true;
}