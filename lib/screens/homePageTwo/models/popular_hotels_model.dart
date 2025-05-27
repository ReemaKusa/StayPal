class PopularHotelsModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isFavorite;

  PopularHotelsModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.isFavorite,
  });

  factory PopularHotelsModel.fromMap(String id, Map<String, dynamic> data) {
    return PopularHotelsModel(
      id: id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }

}
