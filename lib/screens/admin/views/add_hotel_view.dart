import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/screens/admin/services/hotel_service.dart';

class AddHotelView extends StatefulWidget {
  final bool assignToCurrentManager;
  const AddHotelView({super.key, this.assignToCurrentManager = false});

  @override
  State<AddHotelView> createState() => _AddHotelViewState();
}

class _AddHotelViewState extends State<AddHotelView> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _imagesCtrl = TextEditingController();

  final _hotelService = HotelService();

  final List<String> _cities = [
    'Jerusalem', 'Ramallah', 'Nablus', 'Hebron', 'Bethlehem',
    'Jenin', 'Tulkarm', 'Qalqilya', 'Salfit', 'Tubas', 'Jericho', 'Gaza',
  ];

  final List<Map<String, dynamic>> _facilityOptions = [
    {'label': 'Spa', 'icon': Icons.spa},
    {'label': 'Gym', 'icon': Icons.fitness_center},
    {'label': 'Free WiFi', 'icon': Icons.wifi},
    {'label': 'Restaurant', 'icon': Icons.restaurant},
  ];

  String? _selectedLocation;
  bool _isFavorite = false;
  List<String> _selectedFacilities = [];
  List<Map<String, dynamic>> _hotelManagers = [];
  String? _selectedManagerId;

  @override
  void initState() {
    super.initState();
    if (!widget.assignToCurrentManager) _loadHotelManagers();
  }

  Future<void> _loadHotelManagers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'hotel_manager')
        .get();

    setState(() {
      _hotelManagers = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          'name': (data['fullName'] ?? 'Unnamed').toString(),
        };
      }).toList();
    });
  }

  Future<void> _submitHotel() async {
    if (_formKey.currentState!.validate()) {
      final managerId = widget.assignToCurrentManager
          ? FirebaseAuth.instance.currentUser!.uid
          : _selectedManagerId;

      final hotelData = {
        'name': _nameCtrl.text,
        'location': _selectedLocation ?? '',
        'description': _descriptionCtrl.text,
        'details': _detailsCtrl.text,
        'price': double.tryParse(_priceCtrl.text) ?? 0.0,
        'images': _imagesCtrl.text
            .split(',')
            .map((url) => url.trim())
            .where((url) => url.isNotEmpty)
            .toList(),        'facilities': _selectedFacilities,
        'isFavorite': _isFavorite,
        'createdAt': DateTime.now(),
        'managerId': managerId,
      };

      await _hotelService.addHotel(hotelData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(' Hotel added successfully')),
      );

      _formKey.currentState!.reset();
      _nameCtrl.clear();
      _priceCtrl.clear();
      _descriptionCtrl.clear();
      _detailsCtrl.clear();
      _imagesCtrl.clear();

      setState(() {
        _selectedFacilities = [];
        _isFavorite = false;
        _selectedLocation = null;
        _selectedManagerId = null;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    _detailsCtrl.dispose();
    _priceCtrl.dispose();
    _imagesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Add Hotel', style: TextStyle(color: AppColors.black,fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.formVertical,
          horizontal: AppPadding.formHorizontal,
        ),
        child: Center(
          child: Container(
            width: AppDimensions.formWidth,
            padding: const EdgeInsets.all(AppPadding.containerPadding),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppBorderRadius.card),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: AppShadows.cardBlur,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Hotel Details',
                    style: TextStyle(
                      fontSize: AppFontSizes.title,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  _buildTextField(_nameCtrl, 'Hotel Name'),
                  const SizedBox(height: AppSpacing.medium),
                  DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    items: _cities
                        .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedLocation = value),
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Select a city' : null,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  _buildTextField(_priceCtrl, 'Price', keyboardType: TextInputType.number),
                  const SizedBox(height: AppSpacing.medium),
                  _buildTextField(_descriptionCtrl, 'Short Description', maxLines: 2),
                  const SizedBox(height: AppSpacing.medium),
                  _buildTextField(_detailsCtrl, 'Detailed Info', maxLines: 3),
                  const SizedBox(height: AppSpacing.medium),
                  _buildTextField(_imagesCtrl, 'Cover Image URL'),
                  const SizedBox(height: AppSpacing.medium),
                  const Text('Facilities', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: AppSpacing.small,
                    runSpacing: AppSpacing.small,
                    children: _facilityOptions.map((facility) {
                      final isSelected = _selectedFacilities.contains(facility['label']);
                      return FilterChip(
                        showCheckmark: false,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              facility['icon'],
                              size: 18,
                              color: isSelected ? Colors.white : AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              facility['label'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            isSelected
                                ? _selectedFacilities.remove(facility['label'])
                                : _selectedFacilities.add(facility['label']);
                          });
                        },
                        backgroundColor: AppColors.white,
                        selectedColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadius.card),
                          side: const BorderSide(color: AppColors.primary),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  SwitchListTile(
                    title: const Text('Is Favorite?'),
                    value: _isFavorite,
                    onChanged: (val) => setState(() => _isFavorite = val),
                  ),
                  if (!widget.assignToCurrentManager)
                    Column(
                      children: [
                        const SizedBox(height: AppSpacing.medium),
                        DropdownButtonFormField<String>(
                          value: _selectedManagerId,
                          decoration: const InputDecoration(
                            labelText: 'Assign Hotel Manager',
                            border: OutlineInputBorder(),
                          ),
                          items: _hotelManagers
                              .map((manager) => DropdownMenuItem<String>(
                                    value: manager['uid'],
                                    child: Text(manager['name'] ?? 'Unnamed'),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _selectedManagerId = value),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please select a manager'
                              : null,
                        ),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.section),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.buttonVertical,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadius.card),
                        ),
                      ),
                      onPressed: _submitHotel,
                      child: const Text(
                        'Add Hotel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? 'Enter $label' : null,
    );
  }
}
