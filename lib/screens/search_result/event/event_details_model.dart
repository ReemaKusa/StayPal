import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailsModel {
  final String eventId;
  final Map<String, dynamic> event;

  EventDetailsModel({
    required this.eventId,
    required this.event,
  });

  factory EventDetailsModel.fromFirestore(DocumentSnapshot doc) {
    return EventDetailsModel(
      eventId: doc.id,
      event: doc.data() as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toMap() {
    return event;
  }
}