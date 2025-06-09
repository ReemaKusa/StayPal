import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/user_model.dart';

class UserDetailsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late UserModel _user;
  bool _isActive = false;
  String _userRole = '';

  bool get isActive => _isActive;
  String get userRole => _userRole;
  UserModel get user => _user;

  void initialize(UserModel user) {
    _user = user;
    _isActive = user.isActive;
    _userRole = user.role;
    notifyListeners();
  }

  Future<void> toggleUserActive(bool value) async {
    _isActive = value;
    notifyListeners();
    await _firestore.collection('users').doc(_user.uid).update({'isActive': value});
  }

  Future<void> toggleUserRole(BuildContext context) async {
    final newRole = _userRole == 'admin' ? 'user' : 'admin';
    await _firestore.collection('users').doc(_user.uid).update({'role': newRole});
    _userRole = newRole;
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Role updated to "$newRole"')),
    );
  }
}