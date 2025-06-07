// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class EventModel {
//   final String eventId;
//   final Map<String, dynamic> event;
//
//   EventModel({
//     required this.eventId,
//     required this.event,
//   });
//
//   String get name => event['name']?.toString() ?? 'No Name';
//   String get location => event['location']?.toString() ?? 'No Location';
//   String get description => event['description']?.toString() ?? 'No Description';
//   String get details => event['details']?.toString() ?? 'No Details';
//
//   double get price {
//     final raw = event['price'];
//     if (raw is num) return raw.toDouble();
//     if (raw is String) return double.tryParse(raw) ?? 0.0;
//     return 0.0;
//   }
//
//   String get time => event['time']?.toString() ?? 'No Time';
//   String get organizerId => event['organizerId'] ?? '';
//
//   DateTime? get date {
//     final raw = event['date'];
//     if (raw is Timestamp) return raw.toDate();
//     if (raw is String) return DateTime.tryParse(raw);
//     return null;
//   }
//
//   List<String> get highlights {
//     if (event['highlights'] is List) {
//       return List<String>.from(event['highlights'].whereType<String>());
//     }
//     return [];
//   }
//
//   List<String> get images {
//     if (event['images'] is List) {
//       return List<String>.from(event['images'].whereType<String>());
//     }
//     return [];
//   }
//
//   bool get isFavorite => event['isFavorite'] ?? false;
//
//   double get rating => (event['rating'] as num?)?.toDouble() ?? 0.0;
//   String get formattedRating => rating > 0 ? '$rating ★' : 'No Rating';
//
//   String get formattedPrice => '${price.toStringAsFixed(2)} ₪';
//
//   factory EventModel.fromDocument(DocumentSnapshot doc) {
//     return EventModel(
//       eventId: doc.id,
//       event: doc.data() as Map<String, dynamic>,
//     );
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class EventModel {
//   final String eventId;
//   final String name;
//   final String description;
//   final String details;
//   final List<String> highlights;
//   final List<String> images;
//   final String location;
//   final DateTime date;
//   final String time;
//   final int limite;
//   final int ticketsSold;
//   final double price;
//   final double rating;
//   final bool isFavorite;
//   final DateTime createdAt;
//   final String? organizerId;
//
//   EventModel({
//     required this.eventId,
//     required this.name,
//     required this.description,
//     required this.details,
//     required this.highlights,
//     required this.images,
//     required this.location,
//     required this.date,
//     required this.time,
//     required this.limite,
//     required this.ticketsSold,
//     required this.price,
//     required this.rating,
//     required this.isFavorite,
//     required this.createdAt,
//     this.organizerId,
//   });
//
//   int get availableTickets => limite - ticketsSold;
//   String get formattedPrice => '${price.toStringAsFixed(2)} ₪';
//
//   factory EventModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//
//     return EventModel(
//       eventId: doc.id,
//       name: data['name'] ?? '',
//       description: data['description'] ?? '',
//       details: data['details'] ?? '',
//       highlights: List<String>.from(data['highlights'] ?? []),
//       images: List<String>.from(data['images'] ?? []),
//       location: data['location'] ?? '',
//       date: (data['date'] as Timestamp).toDate(),
//       time: data['time'] ?? '',
//       limite: data['limite'] ?? 0,
//       ticketsSold: data['ticketsSold'] ?? 0,
//       price: (data['price'] as num?)?.toDouble() ?? 0.0,
//       rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
//       isFavorite: data['isFavorite'] ?? false,
//       createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       organizerId: data['organizerId'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'description': description,
//       'details': details,
//       'highlights': highlights,
//       'images': images,
//       'location': location,
//       'date': Timestamp.fromDate(date),
//       'time': time,
//       'limite': limite,
//       'ticketsSold': ticketsSold,
//       'price': price,
//       'rating': rating,
//       'isFavorite': isFavorite,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'organizerId': organizerId,
//     };
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String eventId;
  final String name;
  final String description;
  final String details;
  final List<String> highlights;
  final List<String> images;
  final String location;
  final DateTime date;
  final String time;
  final int limite;
  final int ticketsSold;
  final double price;
  final double rating;
  final bool isFavorite;
  final DateTime createdAt;
  final String? organizerId;

  EventModel({
    required this.eventId,
    required this.name,
    required this.description,
    required this.details,
    required this.highlights,
    required this.images,
    required this.location,
    required this.date,
    required this.time,
    required this.limite,
    required this.ticketsSold,
    required this.price,
    required this.rating,
    required this.isFavorite,
    required this.createdAt,
    this.organizerId,
  });

  int get availableTickets => limite - ticketsSold;
  String get formattedPrice => '${price.toStringAsFixed(2)} ₪';

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return EventModel(
      eventId: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      details: data['details'] ?? '',
      highlights: data['highlights'] is List
          ? List<String>.from(data['highlights'].whereType<String>())
          : [],
      images: data['images'] is List
          ? List<String>.from(data['images'].whereType<String>())
          : [],
      location: data['location'] ?? '',
      date: data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : (data['date'] is String
          ? DateTime.tryParse(data['date'])
          : null) ?? DateTime.now(),
      time: data['time'] ?? '',
      limite: data['limite'] ?? 0,
      ticketsSold: data['ticketsSold'] ?? 0,
      price: data['price'] is num
          ? (data['price'] as num).toDouble()
          : (data['price'] is String
          ? double.tryParse(data['price']) ?? 0.0
          : 0.0),

      rating: data['rating'] is num
          ? (data['rating'] as num).toDouble()
          : (data['rating'] is String
          ? double.tryParse(data['rating']) ?? 0.0
          : 0.0),
      isFavorite: data['isFavorite'] ?? false,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : (data['createdAt'] is String
          ? DateTime.tryParse(data['createdAt'])
          : null) ?? DateTime.now(),
      organizerId: data['organizerId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'details': details,
      'highlights': highlights,
      'images': images,
      'location': location,
      'date': Timestamp.fromDate(date),
      'time': time,
      'limite': limite,
      'ticketsSold': ticketsSold,
      'price': price,
      'rating': rating,
      'isFavorite': isFavorite,
      'createdAt': Timestamp.fromDate(createdAt),
      'organizerId': organizerId,
    };
  }
}


