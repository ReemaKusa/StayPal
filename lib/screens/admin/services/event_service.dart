import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/event_model.dart';

class EventService {
  final eventRef = FirebaseFirestore.instance.collection('event');

  Future<void> addEvent(Map<String, dynamic> eventData) async {
    final snapshot = await eventRef.get();

    // Generate next event ID like event01, event02, etc.
    final existingIds = snapshot.docs
        .map((doc) => int.tryParse(doc.id.replaceAll('event', '')))
        .whereType<int>()
        .toList();

    final nextId = existingIds.isEmpty ? 1 : (existingIds.reduce((a, b) => a > b ? a : b) + 1);
    final nextEventId = 'event${nextId.toString().padLeft(2, '0')}';

    await eventRef.doc(nextEventId).set(eventData);
  }

  Future<void> updateEvent(String id, Map<String, dynamic> eventData) async {
    await eventRef.doc(id).update(eventData);
  }

  Future<void> deleteEvent(String id) async {
    await eventRef.doc(id).delete();
  }

  Future<List<EventModel>> fetchEvents() async {
    final snapshot = await eventRef.get();
    return snapshot.docs
        .map((doc) => EventModel(eventId: doc.id, event: doc.data()))
        .toList();
  }
}