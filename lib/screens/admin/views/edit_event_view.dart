import 'package:flutter/material.dart';
import 'package:staypal/screens/admin/models/event_model.dart';
import 'package:staypal/screens/admin/services/event_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventView extends StatefulWidget {
  final EventModel event;
  const EditEventView({super.key, required this.event});

  @override
  State<EditEventView> createState() => _EditEventViewState();
}

class _EditEventViewState extends State<EditEventView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _highlightsCtrl = TextEditingController();

  final _cities = [
    'Jerusalem', 'Ramallah', 'Nablus', 'Hebron', 'Bethlehem',
    'Jenin', 'Tulkarm', 'Qalqilya', 'Salfit', 'Tubas', 'Jericho', 'Gaza',
  ];

  String? _selectedLocation;
  bool _isFavorite = false;
  bool _isAdmin = false;
  List<Map<String, String>> _organizers = [];
  String? _selectedOrganizerId;

  final _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.event.name;
    _priceCtrl.text = widget.event.price.toString();
    _descriptionCtrl.text = widget.event.description;
    _detailsCtrl.text = widget.event.details;
    _imageCtrl.text = widget.event.images.isNotEmpty ? widget.event.images.first : '';
    _selectedLocation = widget.event.location;
    _dateCtrl.text = widget.event.date?.toIso8601String().substring(0, 10) ?? '';
    _timeCtrl.text = widget.event.time;
    _highlightsCtrl.text = widget.event.highlights.join(', ');
    _isFavorite = widget.event.isFavorite;
    _selectedOrganizerId = widget.event.organizerId;

    _checkAdminAndFetchOrganizers();
  }

  Future<void> _checkAdminAndFetchOrganizers() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists && userDoc.data()?['role'] == 'admin') {
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descriptionCtrl.dispose();
    _detailsCtrl.dispose();
    _imageCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    _highlightsCtrl.dispose();
    super.dispose();
  }

  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'name': _nameCtrl.text,
        'location': _selectedLocation ?? '',
        'price': double.tryParse(_priceCtrl.text) ?? 0.0,
        'description': _descriptionCtrl.text,
        'details': _detailsCtrl.text,
        'images': _imageCtrl.text.isNotEmpty ? [_imageCtrl.text] : [],
        'date': DateTime.tryParse(_dateCtrl.text),
        'time': _timeCtrl.text.trim(),
        'highlights': _highlightsCtrl.text.split(',').map((e) => e.trim()).toList(),
        'isFavorite': _isFavorite,
        'updatedAt': DateTime.now(),
        'organizerId': _selectedOrganizerId,
      };

      await _eventService.updateEvent(widget.event.eventId, updatedData);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event updated successfully')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _deleteEvent() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this event? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      await _eventService.deleteEvent(widget.event.eventId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Edit Event')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Center(
          child: Container(
            width: 600,
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
                  const Text('Edit Event Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Event Name', border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Enter event name' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    items: _cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                    onChanged: (value) => setState(() => _selectedLocation = value!),
                    decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
                    validator: (value) => value == null || value.isEmpty ? 'Select a city' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Enter price' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionCtrl,
                    decoration: const InputDecoration(labelText: 'Short Description', border: OutlineInputBorder()),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _detailsCtrl,
                    decoration: const InputDecoration(labelText: 'Detailed Info', border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _imageCtrl,
                    decoration: const InputDecoration(labelText: 'Image URL', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateCtrl,
                    decoration: const InputDecoration(labelText: 'Date (yyyy-MM-dd)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _timeCtrl,
                    decoration: const InputDecoration(labelText: 'Time (e.g. 7:00pm)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _highlightsCtrl,
                    decoration: const InputDecoration(labelText: 'Highlights (comma separated)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Is Favorite?'),
                    value: _isFavorite,
                    onChanged: (val) => setState(() => _isFavorite = val),
                  ),
                  if (_isAdmin)
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedOrganizerId,
                          items: _organizers.map((org) {
                            return DropdownMenuItem(
                              value: org['uid'],
                              child: Text(org['name'] ?? 'Unnamed'),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedOrganizerId = val),
                          decoration: const InputDecoration(labelText: 'Assigned Organizer', border: OutlineInputBorder()),
                          validator: (val) => val == null ? 'Select an organizer' : null,
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          ),
                          onPressed: _updateEvent,
                          child: const Text('Update Event'),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          ),
                          onPressed: _deleteEvent,
                          icon: const Icon(Icons.delete_forever),
                          label: const Text('Delete Event'),
                        ),
                      ],
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