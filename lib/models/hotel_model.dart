import 'package:cloud_firestore/cloud_firestore.dart';

class HotelModel {
  final String hotelId;
  final Map<String, dynamic> hotel;

  HotelModel({
    required this.hotelId,
    required this.hotel,
  });

  String get name => hotel['name']?.toString() ?? 'No Name';
  String get location => hotel['location']?.toString() ?? 'No Location';
  String get description => hotel['description']?.toString() ?? 'No Description';
  String get details => hotel['details']?.toString() ?? 'No Details';
  double get price {
    final raw = hotel['price'];
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw) ?? 0.0;
    return 0.0;
  }
  String get formattedPrice => '${price.toStringAsFixed(2)} ₪';

  double get rating => (hotel['rating'] as num?)?.toDouble() ?? 0.0;
  String get formattedRating => rating > 0 ? '$rating ★' : 'No Rating';

  List<String> get images {
    if (hotel['images'] is List) {
      return List<String>.from(hotel['images'].whereType<String>());
    }
    return [];
  }

  factory HotelModel.fromDocument(DocumentSnapshot doc) {
    return HotelModel(
      hotelId: doc.id,
      hotel: doc.data() as Map<String, dynamic>,
    );
  }
}