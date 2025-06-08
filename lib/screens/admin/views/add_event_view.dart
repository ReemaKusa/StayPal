// import 'package:flutter/material.dart';
// import 'package:staypal/screens/admin/services/event_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:staypal/models/event_model.dart';
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
//   final _descriptionCtrl = TextEditingController();
//   final _detailsCtrl = TextEditingController();
//   final _priceCtrl = TextEditingController();
//   final _imageCtrl = TextEditingController();
//   final _dateCtrl = TextEditingController();
//   final _timeCtrl = TextEditingController();
//   final _highlightsCtrl = TextEditingController();
//
//   final _eventService = EventService();
//
//   static const double kPadding = 16.0;
//   static const double kCardRadius = 12.0;
//   static const double kCardElevation = 12.0;
//
//   final List<String> _cities = [
//     'Jerusalem', 'Ramallah', 'Nablus', 'Hebron', 'Bethlehem',
//     'Jenin', 'Tulkarm', 'Qalqilya', 'Salfit', 'Tubas', 'Jericho', 'Gaza',
//   ];
//   String? _selectedLocation;
//   bool _isFavorite = false;
//
//   List<Map<String, String>> _organizers = [];
//   String? _selectedOrganizerId;
//   bool _isAdmin = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadRoleAndOrganizers();
//   }
//
//   Future<void> _loadRoleAndOrganizers() async {
//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//     final role = doc.data()?['role'];
//
//     if (role == 'admin') {
//       setState(() => _isAdmin = true);
//
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('role', isEqualTo: 'event_organizer')
//           .get();
//
//       final organizers = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return {
//           'uid': doc.id,
//           'name': data['fullName']?.toString() ?? 'Unnamed',
//         };
//       }).toList();
//
//       setState(() {
//         _organizers = organizers;
//       });
//     }
//   }
//
//   void _submitEvent() async {
//     if (_formKey.currentState!.validate()) {
//       final currentUserId = FirebaseAuth.instance.currentUser!.uid;
//
//       final newEvent = EventModel(
//         eventId: '', // Will be assigned in service
//         name: _nameCtrl.text,
//         location: _selectedLocation ?? '',
//         description: _descriptionCtrl.text,
//         details: _detailsCtrl.text,
//         price: double.tryParse(_priceCtrl.text) ?? 0.0,
//         images: _imageCtrl.text.isNotEmpty ? [_imageCtrl.text] : [],
//         date: DateTime.tryParse(_dateCtrl.text.trim()) ?? DateTime.now(),
//         time: _timeCtrl.text.trim(),
//         highlights: _highlightsCtrl.text.split(',').map((e) => e.trim()).toList(),
//         isFavorite: _isFavorite,
//         createdAt: DateTime.now(),
//         rating: 0.0,
//         ticketsSold: 0,
//         limite: 0,
//         organizerId: _isAdmin ? _selectedOrganizerId ?? '' : currentUserId,
//       );
//
//       await _eventService.addEvent(newEvent);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Event added successfully')),
//       );
//
//       _formKey.currentState!.reset();
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
//         _selectedOrganizerId = null;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameCtrl.dispose();
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
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final containerWidth = screenWidth < 700 ? screenWidth * 0.9 : 600.0;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//         title: const Text(
//           'Add Event',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(vertical: 32),
//         child: Center(
//           child: Container(
//             width: containerWidth,
//             padding: const EdgeInsets.all(kPadding + 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(kCardRadius),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Add Event Details',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     controller: _nameCtrl,
//                     decoration: const InputDecoration(
//                       labelText: 'Event Name',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) => value!.isEmpty ? 'Enter event name' : null,
//                   ),
//                   const SizedBox(height: kPadding),
//                   DropdownButtonFormField<String>(
//                     value: _selectedLocation,
//                     items: _cities.map((city) {
//                       return DropdownMenuItem(value: city, child: Text(city));
//                     }).toList(),
//                     onChanged: (value) => setState(() => _selectedLocation = value!),
//                     decoration: const InputDecoration(
//                       labelText: 'City',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) => value == null || value.isEmpty ? 'Select a city' : null,
//                   ),
//                   const SizedBox(height: kPadding),
//                   if (_isAdmin)
//                     DropdownButtonFormField<String>(
//                       value: _selectedOrganizerId,
//                       items: _organizers.map((org) {
//                         return DropdownMenuItem(
//                           value: org['uid'],
//                           child: Text(org['name'] ?? 'Unnamed'),
//                         );
//                       }).toList(),
//                       onChanged: (val) => setState(() => _selectedOrganizerId = val),
//                       decoration: const InputDecoration(
//                         labelText: 'Assign to Event Organizer',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (val) => val == null ? 'Select an organizer' : null,
//                     ),
//                   if (_isAdmin) const SizedBox(height: kPadding),
//                   TextFormField(
//                     controller: _priceCtrl,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
//                     validator: (value) => value!.isEmpty ? 'Enter price' : null,
//                   ),
//                   const SizedBox(height: kPadding),
//                   TextFormField(
//                     controller: _descriptionCtrl,
//                     decoration: const InputDecoration(labelText: 'Short Description', border: OutlineInputBorder()),
//                     maxLines: 2,
//                   ),
//                   const SizedBox(height: kPadding),
//                   TextFormField(
//                     controller: _detailsCtrl,
//                     decoration: const InputDecoration(labelText: 'Detailed Info', border: OutlineInputBorder()),
//                     maxLines: 3,
//                   ),
//                   const SizedBox(height: kPadding),
//                   TextFormField(
//                     controller: _imageCtrl,
//                     decoration: const InputDecoration(labelText: 'Image URL', border: OutlineInputBorder()),
//                   ),
//                   const SizedBox(height: kPadding),
//                   TextFormField(
//                     controller: _dateCtrl,
//                     decoration: const InputDecoration(labelText: 'Date (yyyy-MM-dd)', border: OutlineInputBorder()),
//                   ),
//                   const SizedBox(height: kPadding),
//                   TextFormField(
//                     controller: _timeCtrl,
//                     decoration: const InputDecoration(labelText: 'Time (e.g. 7:00pm)', border: OutlineInputBorder()),
//                   ),
//                   const SizedBox(height: kPadding),
//                   TextFormField(
//                     controller: _highlightsCtrl,
//                     decoration: const InputDecoration(labelText: 'Highlights (comma separated)', border: OutlineInputBorder()),
//                   ),
//                   const SizedBox(height: kPadding),
//                   SwitchListTile(
//                     title: const Text('Is Favorite?'),
//                     value: _isFavorite,
//                     onChanged: (val) => setState(() => _isFavorite = val),
//                   ),
//                   const SizedBox(height: kPadding + 4),
//                   Center(
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepOrange,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(kCardRadius),
//                           ),
//                         ),
//                         onPressed: _submitEvent,
//                         child: const Text(
//                           'Add Event',
//                           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:staypal/screens/admin/services/event_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/event_model.dart';

class AddEventView extends StatefulWidget {
  const AddEventView({super.key});

  @override
  State<AddEventView> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _limiteCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _highlightsCtrl = TextEditingController();

  final _eventService = EventService();

  static const double kPadding = 16.0;
  static const double kCardRadius = 12.0;
  static const double kCardElevation = 12.0;

  final List<String> _cities = [
    'Jerusalem', 'Ramallah', 'Nablus', 'Hebron', 'Bethlehem',
    'Jenin', 'Tulkarm', 'Qalqilya', 'Salfit', 'Tubas', 'Jericho', 'Gaza',
  ];
  String? _selectedLocation;
  bool _isFavorite = false;

  List<Map<String, String>> _organizers = [];
  String? _selectedOrganizerId;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadRoleAndOrganizers();
  }

  Future<void> _loadRoleAndOrganizers() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final role = doc.data()?['role'];

    if (role == 'admin') {
      setState(() => _isAdmin = true);

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'event_organizer')
          .get();

      final organizers = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          'name': data['fullName']?.toString() ?? 'Unnamed',
        };
      }).toList();

      setState(() {
        _organizers = organizers;
      });
    }
  }

  void _submitEvent() async {
    if (_formKey.currentState!.validate()) {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      final newEvent = EventModel(
        eventId: '', // Will be assigned in service
        name: _nameCtrl.text,
        location: _selectedLocation ?? '',
        description: _descriptionCtrl.text,
        details: _detailsCtrl.text,
        price: double.tryParse(_priceCtrl.text) ?? 0.0,
        images: _imageCtrl.text
            .split(',')
            .map((url) => url.trim())
            .where((url) => url.isNotEmpty)
            .toList(),
        date: DateTime.tryParse(_dateCtrl.text.trim()) ?? DateTime.now(),
        time: _timeCtrl.text.trim(),
        highlights: _highlightsCtrl.text.split(',').map((e) => e.trim()).toList(),
        isFavorite: _isFavorite,
        createdAt: DateTime.now(),
        rating: 0.0,
        ticketsSold: 0,
        limite: int.tryParse(_limiteCtrl.text) ?? 0,
        organizerId: _isAdmin ? _selectedOrganizerId ?? '' : currentUserId,
      );

      await _eventService.addEvent(newEvent);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added successfully')),
      );

      _formKey.currentState!.reset();
      _nameCtrl.clear();
      _priceCtrl.clear();
      _limiteCtrl.clear();
      _descriptionCtrl.clear();
      _detailsCtrl.clear();
      _imageCtrl.clear();
      _dateCtrl.clear();
      _timeCtrl.clear();
      _highlightsCtrl.clear();

      setState(() {
        _selectedLocation = null;
        _isFavorite = false;
        _selectedOrganizerId = null;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _detailsCtrl.dispose();
    _priceCtrl.dispose();
    _limiteCtrl.dispose();
    _imageCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    _highlightsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth < 700 ? screenWidth * 0.9 : 600.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Add Event',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Container(
            width: containerWidth,
            padding: const EdgeInsets.all(kPadding + 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(kCardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Event Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Event Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter event name' : null,
                  ),
                  const SizedBox(height: kPadding),
                  DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    items: _cities.map((city) {
                      return DropdownMenuItem(value: city, child: Text(city));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedLocation = value!),
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Select a city' : null,
                  ),
                  const SizedBox(height: kPadding),
                  if (_isAdmin)
                    DropdownButtonFormField<String>(
                      value: _selectedOrganizerId,
                      items: _organizers.map((org) {
                        return DropdownMenuItem(
                          value: org['uid'],
                          child: Text(org['name'] ?? 'Unnamed'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedOrganizerId = val),
                      decoration: const InputDecoration(
                        labelText: 'Assign to Event Organizer',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null ? 'Select an organizer' : null,
                    ),
                  if (_isAdmin) const SizedBox(height: kPadding),
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Enter price' : null,
                  ),
                  const SizedBox(height: kPadding),
                  TextFormField(
                    controller: _limiteCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Available Tickets', border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Enter available tickets' : null,
                  ),
                  const SizedBox(height: kPadding),
                  TextFormField(
                    controller: _descriptionCtrl,
                    decoration: const InputDecoration(labelText: 'Short Description', border: OutlineInputBorder()),
                    maxLines: 2,
                  ),
                  const SizedBox(height: kPadding),
                  TextFormField(
                    controller: _detailsCtrl,
                    decoration: const InputDecoration(labelText: 'Detailed Info', border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                  const SizedBox(height: kPadding),
                  TextFormField(
                    controller: _imageCtrl,
                    decoration: const InputDecoration(labelText: 'Image URL', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: kPadding),
                  TextFormField(
                    controller: _dateCtrl,
                    decoration: const InputDecoration(labelText: 'Date (yyyy-MM-dd)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: kPadding),
                  TextFormField(
                    controller: _timeCtrl,
                    decoration: const InputDecoration(labelText: 'Time (e.g. 7:00pm)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: kPadding),
                  TextFormField(
                    controller: _highlightsCtrl,
                    decoration: const InputDecoration(labelText: 'Highlights (comma separated)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: kPadding),
                  SwitchListTile(
                    title: const Text('Is Favorite?'),
                    value: _isFavorite,
                    onChanged: (val) => setState(() => _isFavorite = val),
                  ),
                  const SizedBox(height: kPadding + 4),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kCardRadius),
                          ),
                        ),
                        onPressed: _submitEvent,
                        child: const Text(
                          'Add Event',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
}