// // File: add_event_view.dart
// import 'package:flutter/material.dart';
// import 'package:staypal/screens/admin/services/event_service.dart';
//
// class AddEventView extends StatefulWidget {
//   const AddEventView({super.key});
//
//   @override
//   State<AddEventView> createState() => _AddEventViewState();
// }
//
// class _AddEventViewState extends State<AddEventView> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _locationCtrl = TextEditingController();
//   final _descriptionCtrl = TextEditingController();
//   final _detailsCtrl = TextEditingController();
//   final _priceCtrl = TextEditingController();
//   final _imageCtrl = TextEditingController();
//   final _dateCtrl = TextEditingController();
//   final _timeCtrl = TextEditingController();
//   final _highlightsCtrl = TextEditingController();
//
//   final _eventService = EventService();
//   final List<String> _cities = [
//     'Jerusalem', 'Ramallah', 'Nablus', 'Hebron', 'Bethlehem',
//     'Jenin', 'Tulkarm', 'Qalqilya', 'Salfit', 'Tubas', 'Jericho', 'Gaza',
//   ];
//
//   String? _selectedLocation;
//   bool _isFavorite = false;
//
//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _locationCtrl.dispose();
//     _descriptionCtrl.dispose();
//     _detailsCtrl.dispose();
//     _priceCtrl.dispose();
//     _imageCtrl.dispose();
//     _dateCtrl.dispose();
//     _timeCtrl.dispose();
//     _highlightsCtrl.dispose();
//     super.dispose();
//   }
//
//   void _submitEvent() async {
//     if (_formKey.currentState!.validate()) {
//       final eventData = {
//         'name': _nameCtrl.text,
//         'location': _selectedLocation ?? '',
//         'description': _descriptionCtrl.text,
//         'details': _detailsCtrl.text,
//         'price': double.tryParse(_priceCtrl.text) ?? 0.0,
//         'images': _imageCtrl.text.isNotEmpty ? [_imageCtrl.text] : [],
//         'date': DateTime.tryParse(_dateCtrl.text.trim()),
//         'time': _timeCtrl.text.trim(),
//         'highlights': _highlightsCtrl.text.split(',').map((e) => e.trim()).toList(),
//         'isFavorite': _isFavorite,
//         'createdAt': DateTime.now(),
//       };
//       await _eventService.addEvent(eventData);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Event added successfully')),
//       );
//
//       _formKey.currentState!.reset();
//
//       _nameCtrl.clear();
//       _priceCtrl.clear();
//       _descriptionCtrl.clear();
//       _detailsCtrl.clear();
//       _imageCtrl.clear();
//       _dateCtrl.clear();
//       _timeCtrl.clear();
//       _highlightsCtrl.clear();
//
//       setState(() {
//         _selectedLocation = null;
//         _isFavorite = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(title: const Text('Add Event')),
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
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Add Event Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _nameCtrl,
//                   decoration: const InputDecoration(
//                     labelText: 'Event Name',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Enter event name' : null,
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
//                   controller: _imageCtrl,
//                   decoration: const InputDecoration(
//                     labelText: 'Image URL',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _dateCtrl,
//                   decoration: const InputDecoration(
//                     labelText: 'Date (yyyy-MM-dd)',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _timeCtrl,
//                   decoration: const InputDecoration(
//                     labelText: 'Time (e.g. 7:00pm)',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _highlightsCtrl,
//                   decoration: const InputDecoration(
//                     labelText: 'Highlights (comma separated)',
//                     border: OutlineInputBorder(),
//                   ),
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
//                       backgroundColor: Colors.deepOrange,
//                       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                     ),
//                     onPressed: _submitEvent,
//                     child: const Text('Add Event'),
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

// File: add_event_view.dart
import 'package:flutter/material.dart';
import 'package:staypal/screens/admin/services/event_service.dart';

class AddEventView extends StatefulWidget {
  const AddEventView({super.key});

  @override
  State<AddEventView> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _highlightsCtrl = TextEditingController();

  final _eventService = EventService();
  final List<String> _cities = [
    'Jerusalem', 'Ramallah', 'Nablus', 'Hebron', 'Bethlehem',
    'Jenin', 'Tulkarm', 'Qalqilya', 'Salfit', 'Tubas', 'Jericho', 'Gaza',
  ];

  String? _selectedLocation;
  bool _isFavorite = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    _detailsCtrl.dispose();
    _priceCtrl.dispose();
    _imageCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    _highlightsCtrl.dispose();
    super.dispose();
  }

  void _submitEvent() async {
    if (_formKey.currentState!.validate()) {
      final eventData = {
        'name': _nameCtrl.text,
        'location': _selectedLocation ?? '',
        'description': _descriptionCtrl.text,
        'details': _detailsCtrl.text,
        'price': double.tryParse(_priceCtrl.text) ?? 0.0,
        'images': _imageCtrl.text.isNotEmpty ? [_imageCtrl.text] : [],
        'date': DateTime.tryParse(_dateCtrl.text.trim()),
        'time': _timeCtrl.text.trim(),
        'highlights': _highlightsCtrl.text.split(',').map((e) => e.trim()).toList(),
        'isFavorite': _isFavorite,
        'createdAt': DateTime.now(),
      };
      await _eventService.addEvent(eventData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added successfully')),
      );

      _formKey.currentState!.reset();
      _nameCtrl.clear();
      _priceCtrl.clear();
      _descriptionCtrl.clear();
      _detailsCtrl.clear();
      _imageCtrl.clear();
      _dateCtrl.clear();
      _timeCtrl.clear();
      _highlightsCtrl.clear();

      setState(() {
        _selectedLocation = null;
        _isFavorite = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth < 700 ? screenWidth * 0.9 : 600.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Add Event')),
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
                  const Text('Add Event Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Event Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter event name' : null,
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
                    controller: _imageCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Date (yyyy-MM-dd)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _timeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Time (e.g. 7:00pm)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _highlightsCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Highlights (comma separated)',
                      border: OutlineInputBorder(),
                    ),
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
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      onPressed: _submitEvent,
                      child: const Text('Add Event'),
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