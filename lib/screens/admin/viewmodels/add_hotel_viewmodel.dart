import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/services/hotel_service.dart';

class AddHotelViewModel extends ChangeNotifier {
  final _hotelService = HotelService();

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final detailsController = TextEditingController();
  final priceController = TextEditingController();
  final imagesController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String? _selectedLocation;
  bool _isFavorite = false;
  List<String> _selectedFacilities = [];
  List<Map<String, dynamic>> _hotelManagers = [];
  String? _selectedManagerId;
  bool _isLoading = false;

  String? get selectedLocation => _selectedLocation;
  bool get isFavorite => _isFavorite;
  List<String> get selectedFacilities => _selectedFacilities;
  List<Map<String, dynamic>> get hotelManagers => _hotelManagers;
  String? get selectedManagerId => _selectedManagerId;
  bool get isLoading => _isLoading;

  final List<String> cities = [
    'Jerusalem',
    'Ramallah',
    'Nablus',
    'Hebron',
    'Bethlehem',
    'Jenin',
    'Tulkarm',
    'Qalqilya',
    'Salfit',
    'Tubas',
    'Jericho',
    'Gaza',
  ];

  final List<Map<String, dynamic>> facilityOptions = [
    {'label': 'Spa', 'icon': Icons.spa},
    {'label': 'Gym', 'icon': Icons.fitness_center},
    {'label': 'Free WiFi', 'icon': Icons.wifi},
    {'label': 'Restaurant', 'icon': Icons.restaurant},
  ];

  void initialize(bool assignToCurrentManager) {
    if (!assignToCurrentManager) {
      loadHotelManagers();
    }
  }

  Future<void> loadHotelManagers() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'hotel_manager')
              .get();

      _hotelManagers =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'uid': doc.id,
              'name': (data['fullName'] ?? 'Unnamed').toString(),
            };
          }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void updateSelectedLocation(String? location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void updateSelectedManager(String? managerId) {
    _selectedManagerId = managerId;
    notifyListeners();
  }

  void toggleFacility(String facilityLabel) {
    if (_selectedFacilities.contains(facilityLabel)) {
      _selectedFacilities.remove(facilityLabel);
    } else {
      _selectedFacilities.add(facilityLabel);
    }
    notifyListeners();
  }

  bool isFacilitySelected(String facilityLabel) {
    return _selectedFacilities.contains(facilityLabel);
  }

  Future<bool> submitHotel(bool assignToCurrentManager) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final managerId =
          assignToCurrentManager
              ? FirebaseAuth.instance.currentUser!.uid
              : _selectedManagerId;

      final hotelData = {
        'name': nameController.text,
        'location': _selectedLocation ?? '',
        'description': descriptionController.text,
        'details': detailsController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'images':
            imagesController.text
                .split(',')
                .map((url) => url.trim())
                .where((url) => url.isNotEmpty)
                .toList(),
        'facilities': _selectedFacilities,
        'isFavorite': _isFavorite,
        'createdAt': DateTime.now(),
        'managerId': managerId,
      };

      await _hotelService.addHotel(hotelData);

      resetForm();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void resetForm() {
    formKey.currentState?.reset();
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    detailsController.clear();
    imagesController.clear();

    _selectedFacilities = [];
    _isFavorite = false;
    _selectedLocation = null;
    _selectedManagerId = null;
    notifyListeners();
  }

  String? validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Enter $fieldName';
    }
    return null;
  }

  String? validateDropdown(String? value, String message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    detailsController.dispose();
    priceController.dispose();
    imagesController.dispose();
    super.dispose();
  }
}
