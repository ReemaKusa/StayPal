import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

mixin LikeManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleHotelLike(
    BuildContext context,
    String id,
    Map<String, dynamic> hotel,
  ) async {
    final currentStatus = hotel['isFavorite'] ?? false;
    final docRef = _firestore.collection('hotel').doc(id);

    try {
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({'isFavorite': !currentStatus});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Favorite status updated!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hotel not found.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status: $e')));
    }
  }

  Future<void> toggleEventLike(
    BuildContext context,
    String id,
    Map<String, dynamic> event,
  ) async {
    final currentStatus = event['isFavorite'] ?? false;
    final docRef = _firestore.collection('event').doc(id);

    try {
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({'isFavorite': !currentStatus});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Favorite status updated!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event not found.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status: $e')));
    }
  }
}