import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/user_model.dart';

class UserService {
  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  Future<List<UserModel>> fetchUsers() async {
    final snapshot = await usersRef.get();
    return snapshot.docs.map((doc) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}