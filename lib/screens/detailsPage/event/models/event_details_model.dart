// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:staypal/models/event_model.dart';
//
// class EventDetailsModel {
//   final String eventId;
//   Map<String, dynamic> event;
//
//   EventDetailsModel({
//     required this.eventId,
//     required this.event,
//   });
//
//   String get name => event['name']?.toString() ?? 'No Name';
//   String get location => event['location']?.toString() ?? 'No Location';
//   String get description => event['description']?.toString() ?? 'No Description';
//   String get details => event['details']?.toString() ?? 'No Details';
//
//   List<String> get images {
//     if (event['images'] is List) {
//       return List<String>.from(event['images'].whereType<String>());
//     }
//     return [];
//   }
//
//   double get price => (event['price'] as num?)?.toDouble() ?? 0.0;
//   String get formattedPrice => '${price.toStringAsFixed(2)} ₪';
//
//   List<String> get highlights {
//     if (event['highlights'] is List) {
//       return List<String>.from(event['highlights'].whereType<String>());
//     }
//     return [];
//   }
//
//   Timestamp? get date => event['date'] is Timestamp ? event['date'] : null;
//
//   String get formattedTime {
//     if (event['time'] is num) {
//       final hours = (event['time'] as num).toInt();
//       final minutes = ((event['time'] as num) - hours) * 60;
//       return '${hours.toString().padLeft(2, '0')}:${minutes.toInt().toString().padLeft(2, '0')}';
//     } else if (event['time'] is String) {
//       return event['time'];
//     }
//     return 'No Time';
//   }
//
//   bool get isFavorite => event['isFavorite'] == true;
//   double get rating => (event['rating'] as num?)?.toDouble() ?? 0.0;
//
//   int get ticketsSold => (event['ticketsSold'] as int?) ?? 0;
//   int get availableTickets {
//     final limit = (event['limite'] as int?) ?? 0;
//     return limit - ticketsSold;
//   }
//
//   Timestamp? get createdAt => event['createdAt'] is Timestamp ? event['createdAt'] : null;
//   String get organizerId => event['organizerId']?.toString() ?? '';
//
//   void updateEvent(Map<String, dynamic> newData) {
//     event.addAll(newData);
//   }
//
//   EventModel toEventModel() {
//     return EventModel(
//       eventId: eventId,
//       name: name,
//       location: location,
//       description: description,
//       details: details,
//       highlights: highlights,
//       images: images,
//       date: date?.toDate() ?? DateTime.now(),
//       time: formattedTime,
//       limite: availableTickets,
//       ticketsSold: ticketsSold,
//       price: price,
//       rating: rating,
//       isFavorite: isFavorite,
//       createdAt: createdAt?.toDate() ?? DateTime.now(),
//       organizerId: organizerId,
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/event_model.dart';

class EventDetailsModel {
  final String eventId;
  Map<String, dynamic> event;

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

  double get price {
    final raw = event['price'];
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw) ?? 0.0;
    return 0.0;
  }

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
    } else if (event['time'] is String) {
      return event['time'];
    }
    return 'No Time';
  }

  bool get isFavorite => event['isFavorite'] == true;

  double get rating {
    final raw = event['rating'];
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw) ?? 0.0;
    return 0.0;
  }

  int get ticketsSold => (event['ticketsSold'] as int?) ?? 0;

  int get availableTickets {
    final limit = (event['limite'] as int?) ?? 0;
    return limit - ticketsSold;
  }

  Timestamp? get createdAt => event['createdAt'] is Timestamp ? event['createdAt'] : null;
  String get organizerId => event['organizerId']?.toString() ?? '';

  void updateEvent(Map<String, dynamic> newData) {
    event.addAll(newData);
  }

  EventModel toEventModel() {
    return EventModel(
      eventId: eventId,
      name: name,
      location: location,
      description: description,
      details: details,
      highlights: highlights,
      images: images,
      date: date?.toDate() ?? DateTime.now(),
      time: formattedTime,
      limite: ((event['limite'] as int?) ?? 0),
      ticketsSold: ticketsSold,
      price: price,
      rating: rating,
      isFavorite: isFavorite,
      createdAt: createdAt?.toDate() ?? DateTime.now(),
      organizerId: organizerId,
    );
  }
}