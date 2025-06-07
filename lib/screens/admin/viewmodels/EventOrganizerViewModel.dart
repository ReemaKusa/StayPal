// import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:staypal/models/event_model.dart';
//
// class EventOrganizerViewModel extends ChangeNotifier {
//   List<EventModel> myEvents = [];
//   bool isLoading = true;
//
//   Future<void> fetchMyEvents() async {
//   try {
//     isLoading = true;
//     notifyListeners();
//
//     final user = FirebaseAuth.instance.currentUser!;
//     final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//     final role = userDoc['role'];
//
//     QuerySnapshot snapshot;
//     if (role == 'admin') {
//       snapshot = await FirebaseFirestore.instance.collection('event').get(); // show all events
//     } else {
//       snapshot = await FirebaseFirestore.instance
//           .collection('event')
//           .where('organizerId', isEqualTo: user.uid)
//           .get();
//     }
//
//     myEvents = snapshot.docs.map((doc) => EventModel.fromDocument(doc)).toList();
//   } catch (e) {
//     print('❌ Failed to fetch events: $e');
//   } finally {
//     isLoading = false;
//     notifyListeners();
//   }
// }
//
//   Future<void> deleteEvent(String eventId) async {
//     await FirebaseFirestore.instance.collection('event').doc(eventId).delete();
//     await fetchMyEvents(); // refresh list after delete
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/models/event_model.dart';

class EventOrganizerViewModel extends ChangeNotifier {
  List<EventModel> myEvents = [];
  bool isLoading = true;

  Future<void> fetchMyEvents() async {
    try {
      isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser!;
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final role = userDoc['role'];

      QuerySnapshot snapshot;
      if (role == 'admin') {
        snapshot =
            await FirebaseFirestore.instance
                .collection('event')
                .get(); // show all events
      } else {
        snapshot =
            await FirebaseFirestore.instance
                .collection('event')
                .where('organizerId', isEqualTo: user.uid)
                .get();
      }

      myEvents =
          snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Failed to fetch events: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    await FirebaseFirestore.instance.collection('event').doc(eventId).delete();
    await fetchMyEvents();
  }
}
