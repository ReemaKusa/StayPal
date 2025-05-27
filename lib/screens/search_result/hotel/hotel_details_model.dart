class HotelDetailsModel {
  final String hotelId;
  final Map<String, dynamic> hotel;
  final bool isInitiallyLiked;

  HotelDetailsModel({
    required this.hotelId,
    required this.hotel,
    this.isInitiallyLiked = false,
  });

  String get name => hotel['name'] ?? 'Hotel Details';
  String get location => hotel['location'] ?? 'Unknown Location';
  String get price => hotel['price']?.toString() ?? 'N/A';
  String get description => hotel['description'] ?? 'No description available';
  String get rating => hotel['rating']?.toString() ?? 'N/A';
  String get details => hotel['details'] ?? 'No details available';
  List<dynamic> get facilities => hotel['facilities'] is List ? hotel['facilities'] : [];
  List<dynamic> get images => hotel['images'] is List ? hotel['images'] : [];
  bool get isFavorite => hotel['isFavorite'] ?? false;
}
