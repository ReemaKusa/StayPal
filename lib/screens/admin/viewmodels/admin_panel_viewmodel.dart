import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController detailsCtrl = TextEditingController();
  final TextEditingController imageUrlsCtrl = TextEditingController();

  String? selectedLocation;
  List<String> selectedFacilities = [];

  final List<String> availableFacilities = [
    'Free WiFi', 'Swimming Pool', 'Parking', 'Gym', 'Spa', 'Restaurant',
  ];

  final List<String> availableLocations = [
    'Ramallah', 'Nablus', 'Hebron', 'Jericho', 'Bethlehem',
    'Jenin', 'Tulkarm', 'Qalqilya', 'Gaza'
  ];

  bool isLoading = false;
  String currentPage = 'dashboard';

  void setPage(String page) {
    currentPage = page;
    notifyListeners();
  }

  Future<void> submitHotel(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    isLoading = true;
    notifyListeners();

    final collection = FirebaseFirestore.instance.collection('hotel');
    final snapshot = await collection.get();
    final nextId = 'hotel${snapshot.docs.length + 1}';

    await collection.doc(nextId).set({
      'name': nameCtrl.text.trim(),
      'location': selectedLocation,
      'price': double.tryParse(priceCtrl.text.trim()) ?? 0.0,
      'description': descCtrl.text.trim(),
      'details': detailsCtrl.text.trim(),
      'facilities': selectedFacilities,
      'images': imageUrlsCtrl.text.trim().split(',').map((e) => e.trim()).toList(),
      'isFavorite': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hotel added successfully')),
    );

    isLoading = false;
    clearForm();
    notifyListeners();
  }

  void clearForm() {
    nameCtrl.clear();
    priceCtrl.clear();
    descCtrl.clear();
    detailsCtrl.clear();
    imageUrlsCtrl.clear();
    selectedFacilities.clear();
    selectedLocation = null;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    descCtrl.dispose();
    detailsCtrl.dispose();
    imageUrlsCtrl.dispose();
    super.dispose();
  }
}