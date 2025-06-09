import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/event_ticket_model.dart';

class EventTicketService {
  Future<List<EventTicketModel>> fetchTickets() async {
    final snapshot = await FirebaseFirestore.instance.collection('eventTickets').get();
    return snapshot.docs.map((doc) => EventTicketModel.fromFirestore(doc)).toList();
  }

  Future<String> getEventNameById(String eventId) async {
    final doc = await FirebaseFirestore.instance.collection('event').doc(eventId).get();
    if (doc.exists) {
      return doc['name'] ?? 'Unnamed Event';
    }
    return 'Unknown Event';
  }
}