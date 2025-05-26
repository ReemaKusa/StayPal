import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailsModel {
  final String eventId;
  final Map<String, dynamic> event;

  EventDetailsModel({
    required this.eventId,
    required this.event,
  });

  // دالة مساعدة لتحويل القيم إلى List<String>
  static List<String> _convertToList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.whereType<String>().toList();
    }
    if (value is String) {
      return value.trim().isNotEmpty ? [value] : [];
    }
    return [];
  }

  // دالة مساعدة لتحويل القيم إلى String
  static String _convertToString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  // دالة مساعدة لتحويل القيم إلى double
  static double _convertToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  String get name => _convertToString(event['title'] ?? 'No Title');
  String get location => _convertToString(event['subtitle'] ?? 'No Location');
  String get description => _convertToString(event['description'] ?? 'No Description');
  
  List<String> get images {
    final imageValue = event['imageUrl'];
    final imagesList = _convertToList(imageValue);
    return imagesList.where((img) => img.trim().isNotEmpty).toList();
  }

  double get price => _convertToDouble(event['price']);
  double get rating => _convertToDouble(event['rating']);
  List<String> get highlights => _convertToList(event['highlights']);
  String get date => _convertToString(event['date'] ?? 'No Date');
  String get time => _convertToString(event['time'] ?? 'No Time');
  bool get isFavorite => event['isFavorite'] == true;
}