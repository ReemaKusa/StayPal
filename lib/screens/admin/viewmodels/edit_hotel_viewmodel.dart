import 'package:flutter/material.dart';
import 'package:staypal/models/hotel_model.dart';
import 'package:staypal/screens/admin/services/hotel_service.dart';

class EditHotelViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();
  final imagesCtrl = TextEditingController();

  final hotelService = HotelService();
  late HotelModel hotel;

  String? selectedLocation;
  List<String> selectedFacilities = [];
  bool isFavorite = false;

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

  void init(HotelModel hotelModel) {
    hotel = hotelModel;
    nameCtrl.text = hotel.name;
    priceCtrl.text = hotel.price.toString();
    descriptionCtrl.text = hotel.description;
    detailsCtrl.text = hotel.details;
    imagesCtrl.text = hotel.images.join(', ');
    selectedLocation = hotel.location;
    selectedFacilities = List<String>.from(hotel.facilities);
    isFavorite = hotel.isFavorite;
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

  Future<void> updateHotel(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final updatedData = {
      'name': nameCtrl.text,
      'location': selectedLocation ?? '',
      'price': double.tryParse(priceCtrl.text) ?? 0.0,
      'description': descriptionCtrl.text,
      'details': detailsCtrl.text,
      'images': imagesCtrl.text
          .split(',')
          .map((url) => url.trim())
          .where((url) => url.isNotEmpty)
          .toList(),
      'facilities': selectedFacilities,
      'isFavorite': isFavorite,
      'updatedAt': DateTime.now(),
    };

    await hotelService.updateHotel(hotel.hotelId, updatedData);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Hotel updated successfully',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> deleteHotel(BuildContext context) async {
    await hotelService.deleteHotel(hotel.hotelId);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    descriptionCtrl.dispose();
    detailsCtrl.dispose();
    imagesCtrl.dispose();
    super.dispose();
  }
}
