import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentMethodsViewModel {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  CollectionReference get cardsRef {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards');
  }

  Future<void> deleteCard(DocumentReference ref) async {
    await ref.delete();
  }

  Stream<QuerySnapshot> getCardStream() {
    return cardsRef.snapshots();
  }
}