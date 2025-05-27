class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String imageUrl;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.imageUrl,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}