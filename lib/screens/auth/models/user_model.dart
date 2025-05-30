class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final DateTime? createdAt;
  final String dob;
  final String gender;
  final String phone;
  final String address;
  final String city;
  final String country;
  final String zipCode;
  final String imageUrl;
  final bool isActive;


  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.dob,
    required this.isActive,
    required this.gender,
    required this.phone,
    required this.address,
    required this.city,
    required this.country,
    required this.zipCode,
    required this.imageUrl,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
      phone: map['phone']?.toString() ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      zipCode: map['zipCode']?.toString() ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: map['createdAt']?.toDate(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'zipCode': zipCode,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}