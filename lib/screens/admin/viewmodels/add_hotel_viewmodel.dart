import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/screens/admin/services/hotel_service.dart';

class AddHotelViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final imagesCtrl = TextEditingController();

  final List<String> cities = [
    'Jerusalem', 'Ramallah', 'Nablus', 'Hebron', 'Bethlehem',
    'Jenin', 'Tulkarm', 'Qalqilya', 'Salfit', 'Tubas', 'Jericho', 'Gaza',
  ];

  final List<Map<String, dynamic>> facilityOptions = [
    {'label': 'Spa', 'icon': Icons.spa},
    {'label': 'Gym', 'icon': Icons.fitness_center},
    {'label': 'Free WiFi', 'icon': Icons.wifi},
    {'label': 'Restaurant', 'icon': Icons.restaurant},
  ];

  List<Map<String, dynamic>> hotelManagers = [];
  List<String> selectedFacilities = [];
  String? selectedLocation;
  String? selectedManagerId;
  bool isFavorite = false;

  final HotelService hotelService = HotelService();

  Future<void> loadHotelManagers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'hotel_manager')
        .get();

    hotelManagers = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'uid': doc.id,
        'name': data['fullName'] ?? 'Unnamed',
      };
    }).toList();

    notifyListeners();
  }

  void toggleFacility(String label) {
    if (selectedFacilities.contains(label)) {
      selectedFacilities.remove(label);
    } else {
      selectedFacilities.add(label);
    }
    notifyListeners();
  }

  void setFavorite(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  void setLocation(String? value) {
    selectedLocation = value;
    notifyListeners();
  }

  void setManager(String? value) {
    selectedManagerId = value;
    notifyListeners();
  }

  Future<void> submitHotel(bool assignToCurrentManager, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final managerId = assignToCurrentManager
          ? FirebaseAuth.instance.currentUser!.uid
          : selectedManagerId;

      final hotelData = {
        'name': nameCtrl.text,
        'location': selectedLocation ?? '',
        'description': descriptionCtrl.text,
        'details': detailsCtrl.text,
        'price': double.tryParse(priceCtrl.text) ?? 0.0,
        'images': imagesCtrl.text
            .split(',')
            .map((url) => url.trim())
            .where((url) => url.isNotEmpty)
            .toList(),
        'facilities': selectedFacilities,
        'isFavorite': isFavorite,
        'createdAt': DateTime.now(),
        'managerId': managerId,
      };

      await hotelService.addHotel(hotelData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hotel added successfully')),
      );

      clearForm();
      notifyListeners();
    }
  }

  void clearForm() {
    nameCtrl.clear();
    locationCtrl.clear();
    descriptionCtrl.clear();
    detailsCtrl.clear();
    priceCtrl.clear();
    imagesCtrl.clear();
    selectedFacilities = [];
    isFavorite = false;
    selectedLocation = null;
    selectedManagerId = null;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    locationCtrl.dispose();
    descriptionCtrl.dispose();
    detailsCtrl.dispose();
    priceCtrl.dispose();
    imagesCtrl.dispose();
    super.dispose();
  }
}
