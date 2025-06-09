import 'package:cloud_firestore/cloud_firestore.dart';

class HotelModel {
  final String hotelId;
  final String name;
  final String location;
  final String description;
  final String details;
  final double price;
  final double rating;
  final List<String> images;
  final List<String> facilities;
  final bool isFavorite;
  final Timestamp? createdAt;
  final String managerId;

  HotelModel({
    required this.hotelId,
    required this.name,
    required this.location,
    required this.description,
    required this.details,
    required this.price,
    required this.rating,
    required this.images,
    required this.facilities,
    required this.isFavorite,
    required this.managerId,
    this.createdAt,
  });

  factory HotelModel.fromDocument(DocumentSnapshot doc) {
    final rawData = doc.data();
    if (rawData == null || rawData is! Map<String, dynamic>) {
      throw StateError('Invalid or missing hotel data for document ID: \${doc.id}');
    }

    return HotelModel(
      hotelId: doc.id,
      name: rawData['name'] ?? '',
      location: rawData['location'] ?? '',
      description: rawData['description'] ?? '',
      details: rawData['details'] ?? '',
      price: (rawData['price'] ?? 0).toDouble(),
      rating: (rawData['rating'] ?? 0).toDouble(),
      images: List<String>.from(rawData['images'] ?? []),
      facilities: List<String>.from(rawData['facilities'] ?? []),
      isFavorite: rawData['isFavorite'] == true,
      createdAt: rawData['createdAt'] is Timestamp ? rawData['createdAt'] as Timestamp : null,
      managerId: rawData['managerId'] ?? '',
    );
  }

  String get formattedPrice => '${price.toStringAsFixed(2)} ₪';
  String get formattedRating => rating > 0 ? '\$rating ★' : 'No Rating';
}
