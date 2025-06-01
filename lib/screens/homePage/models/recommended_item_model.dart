class RecommendedItemModel {
  final String id;
  final String type; // hotel or event
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isFavorite;

  RecommendedItemModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.isFavorite,
  });

  factory RecommendedItemModel.fromMap(String id, Map<String, dynamic> data) {
    return RecommendedItemModel(
      id: id,
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }
}
