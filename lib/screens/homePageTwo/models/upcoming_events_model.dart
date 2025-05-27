class UpcomingEventsModel {

  
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String description;
  final bool isFavorite;
  final String? price; 

  UpcomingEventsModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.description,
    required this.isFavorite,
    this.price,
  });

  factory UpcomingEventsModel.fromMap(String id, Map<String, dynamic> data) {
    return UpcomingEventsModel(
      id: id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }
}
