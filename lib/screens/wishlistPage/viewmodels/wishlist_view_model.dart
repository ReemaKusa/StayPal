import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import'./details_bottom_sheet.dart';

class WishListViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateFormat _dateFormat = DateFormat('MMM d');

  Stream<List<QueryDocumentSnapshot>> get wishlistStream =>
      CombineLatestStream.combine2<QuerySnapshot, QuerySnapshot, List<QueryDocumentSnapshot>>(
        _firestore.collection('hotel').where('isFavorite', isEqualTo: true).snapshots(),
        _firestore.collection('event').where('isFavorite', isEqualTo: true).snapshots(),
        (hotelsSnap, eventsSnap) => [...hotelsSnap.docs, ...eventsSnap.docs],
      );

  String getImageUrl(dynamic images) {
    if (images is List && images.isNotEmpty) {
      return images.first.toString();
    } else if (images is String) {
      return images;
    }
    return '';
  }

  String getSubtitle(Map<String, dynamic> item, bool isHotel) {
    if (isHotel) {
      return item['location'] ?? '';
    } else {
      if (item['date'] is Timestamp) {
        return _dateFormat.format((item['date'] as Timestamp).toDate());
      }
      return item['date']?.toString() ?? '';
    }
  }

  void handleMenuSelection(
    BuildContext context,
    String value,
    DocumentReference reference,
    String? name,
  ) {
    if (value == 'remove') {
      reference.update({'isFavorite': false});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name removed from wishlist')),
      );
    } else if (value == 'share') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sharing $name...')),
      );
    }
  }

  void showDetailsBottomSheet(
    BuildContext context,
    Map<String, dynamic> item,
    bool isHotel,
    String id,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DetailsBottomSheet(
        item: item,
        isHotel: isHotel,
        id: id,
        viewModel: this,
      ),
    );
  }
}