import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/event_model.dart';

class EventService {
  final eventRef = FirebaseFirestore.instance.collection('event');

  Future<void> addEvent(EventModel event) async {
    final snapshot = await eventRef.get();

    final existingIds =
        snapshot.docs
            .map((doc) => int.tryParse(doc.id.replaceAll('event', '')))
            .whereType<int>()
            .toList();

    final nextId =
        existingIds.isEmpty
            ? 1
            : (existingIds.reduce((a, b) => a > b ? a : b) + 1);
    final nextEventId = 'event${nextId.toString().padLeft(2, '0')}';

    await eventRef.doc(nextEventId).set(event.toMap());
  }

  Future<void> updateEvent(String id, EventModel event) async {
    await eventRef.doc(id).update(event.toMap());
  }

  Future<String> getEventNameById(String eventId) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .get();
    return doc.exists
        ? (doc.data()?['name'] ?? 'Unnamed Event')
        : 'Unknown Event';
  }

  Future<void> deleteEvent(String id) async {
    await eventRef.doc(id).delete();
  }

  Future<List<EventModel>> fetchEvents() async {
    final snapshot = await eventRef.get();
    return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
  }

  Future<EventModel?> getEventById(String id) async {
    final doc = await eventRef.doc(id).get();
    if (doc.exists) {
      return EventModel.fromFirestore(doc);
    }
    return null;
  }
}
