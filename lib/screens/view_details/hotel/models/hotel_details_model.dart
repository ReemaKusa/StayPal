import 'package:cloud_firestore/cloud_firestore.dart';

class HotelDetailsModel {
  final String hotelId;
  final Map<String, dynamic> hotel;

  HotelDetailsModel({
    required this.hotelId,
    required this.hotel,
  });

  String get name => hotel['name']?.toString() ?? 'No Name';
  String get location => hotel['location']?.toString() ?? 'No Location';
  String get description => hotel['description']?.toString() ?? 'No Description';
  String get details => hotel['details']?.toString() ?? 'No Details';

  List<String> get images {
    if (hotel['images'] is List) {
      return List<String>.from(hotel['images'].whereType<String>());
    }
    return [];
  }

  double get price => (hotel['price'] as num?)?.toDouble() ?? 0.0;
  String get formattedPrice => '${price.toStringAsFixed(2)} ₪';

  double get rating => (hotel['rating'] as num?)?.toDouble() ?? 0.0;
  String get formattedRating => rating > 0 ? rating.toStringAsFixed(1) : 'No Rating';

  List<String> get facilities {
    if (hotel['facilities'] is List) {
      return List<String>.from(hotel['facilities'].whereType<String>());
    }
    return [];
  }

  bool get isFavorite => hotel['isFavorite'] == true;
}
