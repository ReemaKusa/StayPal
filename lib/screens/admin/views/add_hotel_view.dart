// import 'package:flutter/material.dart';
// import 'package:staypal/screens/admin/services/hotel_service.dart';
// import 'package:staypal/screens/admin/models/hotel_model.dart';
//
// class AddHotelView extends StatefulWidget {
//   const AddHotelView({super.key});
//
//   @override
//   State<AddHotelView> createState() => _AddHotelViewState();
// }
//
// class _AddHotelViewState extends State<AddHotelView> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _locationCtrl = TextEditingController();
//   final _descriptionCtrl = TextEditingController();
//   final _detailsCtrl = TextEditingController();
//   final _priceCtrl = TextEditingController();
//   final _imagesCtrl = TextEditingController();
//
//   final _hotelService = HotelService();
//   final List<String> _cities = [
//     'Jerusalem',
//     'Ramallah',
//     'Nablus',
//     'Hebron',
//     'Bethlehem',
//     'Jenin',
//     'Tulkarm',
//     'Qalqilya',
//     'Salfit',
//     'Tubas',
//     'Jericho',
//     'Gaza',
//   ];
//
//   String? _selectedLocation;
//
//   bool _isFavorite = false;
//   List<String> _selectedFacilities = [];
//   final List<String> _facilityOptions = [
//     '🧖‍♀️Spa',
//     '💪 Gym',
//     ' 🛜 Free WiFi',
//     '🍽 Restaurant',
//   ];
//
//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _locationCtrl.dispose();
//     _descriptionCtrl.dispose();
//     _detailsCtrl.dispose();
//     _priceCtrl.dispose();
//     _imagesCtrl.dispose();
//     super.dispose();
//   }
//
//   void _submitHotel() async {
//     if (_formKey.currentState!.validate()) {
//       final hotelData = {
//         'name': _nameCtrl.text,
//         'location': _selectedLocation ?? '',
//         'description': _descriptionCtrl.text,
//         'details': _detailsCtrl.text,
//         'price': double.tryParse(_priceCtrl.text) ?? 0.0,
//         'images': _imagesCtrl.text.isNotEmpty ? [_imagesCtrl.text] : [],
//         'facilities': _selectedFacilities,
//         'isFavorite': _isFavorite,
//         'createdAt': DateTime.now(),
//       };
//       await _hotelService.addHotel(hotelData);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Hotel added successfully')),
//       );
//
//       _formKey.currentState!.reset();
//
//       _nameCtrl.clear();
//       _priceCtrl.clear();
//       _descriptionCtrl.clear();
//       _detailsCtrl.clear();
//       _imagesCtrl.clear();
//
//       setState(() {
//         _selectedFacilities = [];
//         _isFavorite = false;
//         _selectedLocation = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(title: const Text('Add Hotel')),
//       body: Center(
//         child: Container(
//           width: 600,
//           padding: const EdgeInsets.all(24),
//           margin: const EdgeInsets.symmetric(vertical: 32),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
//           ),
//           child: SingleChildScrollView(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Add Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _nameCtrl,
//                   decoration: const InputDecoration(
//                     labelText: 'Hotel Name',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Enter hotel name' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: _selectedLocation,
//                   items: _cities.map((city) {
//                     return DropdownMenuItem(
//                       value: city,
//                       child: Text(city),
//                     );
//                   }).toList(),
//                   onChanged: (value) => setState(() => _selectedLocation = value!),
//                   decoration: const InputDecoration(
//                     labelText: 'City',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) => value == null || value.isEmpty ? 'Select a city' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _priceCtrl,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     labelText: 'Price',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Enter price' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _descriptionCtrl,
//                   decoration: const InputDecoration(
//                     labelText: 'Short Description',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 2,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _detailsCtrl,
//                   decoration: const InputDecoration(
//                     labelText: 'Detailed Info',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 3,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _imagesCtrl,
//                   decoration: const InputDecoration(
//                     labelText: 'Cover Image URL',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text('Facilities', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Wrap(
//                   spacing: 8.0,
//                   children: _facilityOptions.map((facility) {
//                     final isSelected = _selectedFacilities.contains(facility);
//                     return FilterChip(
//                       label: Text(facility),
//                       selected: isSelected,
//                       onSelected: (selected) {
//                         setState(() {
//                           isSelected
//                               ? _selectedFacilities.remove(facility)
//                               : _selectedFacilities.add(facility);
//                         });
//                       },
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 16),
//                 SwitchListTile(
//                   title: const Text('Is Favorite?'),
//                   value: _isFavorite,
//                   onChanged: (val) => setState(() => _isFavorite = val),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepPurple,
//                       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                     ),
//                     onPressed: _submitHotel,
//                     child: const Text('Add Details'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// File: add_hotel_view.dart
// File: add_hotel_view.dart
import 'package:flutter/material.dart';
import 'package:staypal/screens/admin/services/hotel_service.dart';
import 'package:staypal/screens/admin/models/hotel_model.dart';

class AddHotelView extends StatefulWidget {
  const AddHotelView({super.key});

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

  String? _selectedLocation;
  bool _isFavorite = false;
  List<String> _selectedFacilities = [];
  final List<String> _facilityOptions = [
    '🧖‍♀️Spa', '💪 Gym', ' 🛜 Free WiFi', '🍽 Restaurant',
  ];

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

  void _submitHotel() async {
    if (_formKey.currentState!.validate()) {
      final hotelData = {
        'name': _nameCtrl.text,
        'location': _selectedLocation ?? '',
        'description': _descriptionCtrl.text,
        'details': _detailsCtrl.text,
        'price': double.tryParse(_priceCtrl.text) ?? 0.0,
        'images': _imagesCtrl.text.isNotEmpty ? [_imagesCtrl.text] : [],
        'facilities': _selectedFacilities,
        'isFavorite': _isFavorite,
        'createdAt': DateTime.now(),
      };
      await _hotelService.addHotel(hotelData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hotel added successfully')),
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth < 700 ? screenWidth * 0.9 : 600.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Add Hotel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Container(
            width: containerWidth,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Hotel Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter hotel name' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    items: _cities.map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedLocation = value!),
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Select a city' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter price' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Short Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _detailsCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Detailed Info',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _imagesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Cover Image URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Facilities', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _facilityOptions.map((facility) {
                      final isSelected = _selectedFacilities.contains(facility);
                      return FilterChip(
                        label: Text(facility),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            isSelected
                                ? _selectedFacilities.remove(facility)
                                : _selectedFacilities.add(facility);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Is Favorite?'),
                    value: _isFavorite,
                    onChanged: (val) => setState(() => _isFavorite = val),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      onPressed: _submitHotel,
                      child: const Text('Add Details'),
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
}