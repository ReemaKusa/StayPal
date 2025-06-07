import 'package:flutter/material.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/admin/services/hotel_service.dart';
import 'package:staypal/models/hotel_model.dart';

class EditHotelView extends StatefulWidget {
  final HotelModel hotel;
  const EditHotelView({super.key, required this.hotel});

  @override
  State<EditHotelView> createState() => _EditHotelViewState();
}

class _EditHotelViewState extends State<EditHotelView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();
  final _imagesCtrl = TextEditingController();

  final _cities = [
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

  final _facilityOptions = [
    {'label': 'Spa', 'icon': Icons.spa},
    {'label': 'Gym', 'icon': Icons.fitness_center},
    {'label': 'Free WiFi', 'icon': Icons.wifi},
    {'label': 'Restaurant', 'icon': Icons.restaurant},
  ];

  String? _selectedLocation;
  List<String> _selectedFacilities = [];
  bool _isFavorite = false;
  final _hotelService = HotelService();

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.hotel.name;
    _priceCtrl.text = widget.hotel.price.toString();
    _descriptionCtrl.text = widget.hotel.description;
    _detailsCtrl.text = widget.hotel.details;
    _imagesCtrl.text = widget.hotel.images.join(', ');
    _selectedLocation = widget.hotel.location;
    _selectedFacilities = List<String>.from(widget.hotel.facilities);
    _isFavorite = widget.hotel.isFavorite;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descriptionCtrl.dispose();
    _detailsCtrl.dispose();
    _imagesCtrl.dispose();
    super.dispose();
  }

  Future<void> _updateHotel() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'name': _nameCtrl.text,
        'location': _selectedLocation ?? '',
        'price': double.tryParse(_priceCtrl.text) ?? 0.0,
        'description': _descriptionCtrl.text,
        'details': _detailsCtrl.text,
        'images': _imagesCtrl.text
            .split(',')
            .map((url) => url.trim())
            .where((url) => url.isNotEmpty)
            .toList(),        'facilities': _selectedFacilities,
        'isFavorite': _isFavorite,
        'updatedAt': DateTime.now(),
      };

      await _hotelService.updateHotel(widget.hotel.hotelId, updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hotel updated successfully'),
            backgroundColor: AppColors.primary,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _deleteHotel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.card),
            ),
            backgroundColor: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.containerPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Confirm Delete',
                    style: TextStyle(
                      fontSize: AppFontSizes.title,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  const Text(
                    'Are you sure you want to delete this hotel?\nThis cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppBorderRadius.card,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.buttonVertical,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppBorderRadius.card,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.buttonVertical,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );

    if (confirmed == true) {
      await _hotelService.deleteHotel(widget.hotel.hotelId);
      if (mounted) Navigator.pop(context);
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          'Edit Hotel',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.black),
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
                    'Edit Hotel Details',
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
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        _cities
                            .map(
                              (city) => DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => setState(() => _selectedLocation = value),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Select a city'
                                : null,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  _buildTextField(
                    _priceCtrl,
                    'Price',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  _buildTextField(
                    _descriptionCtrl,
                    'Short Description',
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  _buildTextField(_detailsCtrl, 'Detailed Info', maxLines: 3),
                  const SizedBox(height: AppSpacing.medium),
                  _buildTextField(_imagesCtrl, 'Cover Image URL'),
                  const SizedBox(height: AppSpacing.medium),
                  const Text(
                    'Facilities',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: AppSpacing.small,
                    runSpacing: AppSpacing.small,
                    children:
                        _facilityOptions.map((facility) {
                          final label = facility['label'] as String;
                          final icon = facility['icon'] as IconData;
                          final isSelected = _selectedFacilities.contains(
                            label,
                          );
                          return FilterChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  size: AppIconSizes.smallIcon,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  label,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedFacilities.add(label);
                                } else {
                                  _selectedFacilities.remove(label);
                                }
                              });
                            },
                            backgroundColor: AppColors.white,
                            selectedColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppBorderRadius.card,
                              ),
                              side: BorderSide(color: AppColors.primary),
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
                  const SizedBox(height: AppSpacing.section),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _updateHotel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.buttonVertical,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppBorderRadius.card,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Update Hotel',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _deleteHotel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.buttonVertical,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppBorderRadius.card,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Delete Hotel',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
