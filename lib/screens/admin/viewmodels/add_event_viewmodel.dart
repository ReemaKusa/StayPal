import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/event_model.dart';
import 'package:staypal/services/event_service.dart';

class AddEventViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final limiteCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  final highlightsCtrl = TextEditingController();

  final eventService = EventService();

  final List<String> cities = [
    'Jerusalem', 'Ramallah', 'Nablus', 'Hebron', 'Bethlehem',
    'Jenin', 'Tulkarm', 'Qalqilya', 'Salfit', 'Tubas', 'Jericho', 'Gaza',
  ];

  String? selectedLocation;
  bool isFavorite = false;

  List<Map<String, String>> organizers = [];
  String? selectedOrganizerId;
  bool isAdmin = false;

  Future<void> loadRoleAndOrganizers() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final role = doc.data()?['role'];

    if (role == 'admin') {
      isAdmin = true;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'event_organizer')
          .get();

      organizers = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          'name': data['fullName']?.toString() ?? 'Unnamed',
        };
      }).toList();
    }

    notifyListeners();
  }

  Future<void> submitEvent(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      final newEvent = EventModel(
        eventId: '',
        name: nameCtrl.text,
        location: selectedLocation ?? '',
        description: descriptionCtrl.text,
        details: detailsCtrl.text,
        price: double.tryParse(priceCtrl.text) ?? 0.0,
        images: imageCtrl.text
            .split(',')
            .map((url) => url.trim())
            .where((url) => url.isNotEmpty)
            .toList(),
        date: DateTime.tryParse(dateCtrl.text.trim()) ?? DateTime.now(),
        time: timeCtrl.text.trim(),
        highlights: highlightsCtrl.text.split(',').map((e) => e.trim()).toList(),
        isFavorite: isFavorite,
        createdAt: DateTime.now(),
        rating: 0.0,
        ticketsSold: 0,
        limite: int.tryParse(limiteCtrl.text) ?? 0,
        organizerId: isAdmin ? selectedOrganizerId ?? '' : currentUserId,
      );

      await eventService.addEvent(newEvent);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added successfully')),
      );

      clearForm();
    }
  }

  void clearForm() {
    formKey.currentState?.reset();
    nameCtrl.clear();
    priceCtrl.clear();
    limiteCtrl.clear();
    descriptionCtrl.clear();
    detailsCtrl.clear();
    imageCtrl.clear();
    dateCtrl.clear();
    timeCtrl.clear();
    highlightsCtrl.clear();

    selectedLocation = null;
    isFavorite = false;
    selectedOrganizerId = null;

    notifyListeners();
  }

  void disposeControllers() {
    nameCtrl.dispose();
    descriptionCtrl.dispose();
    detailsCtrl.dispose();
    priceCtrl.dispose();
    limiteCtrl.dispose();
    imageCtrl.dispose();
    dateCtrl.dispose();
    timeCtrl.dispose();
    highlightsCtrl.dispose();
  }
}
