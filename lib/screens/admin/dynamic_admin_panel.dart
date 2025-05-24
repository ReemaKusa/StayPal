import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DynamicAdminPanel extends StatefulWidget {
  const DynamicAdminPanel({super.key});

  @override
  State<DynamicAdminPanel> createState() => _DynamicAdminPanelState();
}

class _DynamicAdminPanelState extends State<DynamicAdminPanel> {
  String? _selectedType;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController locationCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController detailsCtrl = TextEditingController();
  final TextEditingController imageUrlsCtrl = TextEditingController();
  final TextEditingController facilitiesCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();
  final TextEditingController highlightsCtrl = TextEditingController();

  bool isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedType == null) return;
    setState(() => isLoading = true);

    try {
      if (_selectedType == 'hotel') {
        final collection = FirebaseFirestore.instance.collection('hotel');
        final snapshot = await collection.get();
        final nextHotelId = 'hotel${snapshot.docs.length + 1}';

        await collection.doc(nextHotelId).set({
          'name': nameCtrl.text.trim(),
          'location': locationCtrl.text.trim(),
          'price': double.tryParse(priceCtrl.text.trim()) ?? 0.0,
          'description': descCtrl.text.trim(),
          'details': detailsCtrl.text.trim(),
          'facilities': facilitiesCtrl.text.trim().split(',').map((e) => e.trim()).toList(),
          'images': imageUrlsCtrl.text.trim().split(',').map((e) => e.trim()).toList(),
          'isFavorite': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else if (_selectedType == 'event') {
        final collection = FirebaseFirestore.instance.collection('event');
        final snapshot = await collection.get();

        final existingIds = snapshot.docs
            .map((doc) => int.tryParse(doc.id.replaceAll('event', '')))
            .whereType<int>()
            .toList();

        final nextId = existingIds.isEmpty ? 1 : (existingIds.reduce((a, b) => a > b ? a : b) + 1);
        final nextEventId = 'event$nextId';

        await collection.doc(nextEventId).set({
          'name': nameCtrl.text.trim(),
          'location': locationCtrl.text.trim(),
          'price': double.tryParse(priceCtrl.text.trim()) ?? 0.0,
          'description': descCtrl.text.trim(),
          'imageUrl': imageUrlsCtrl.text.trim(),
          'date': DateTime.tryParse(dateCtrl.text.trim()) ?? DateTime.now(),
          'time': timeCtrl.text.trim(),
          'highlights': highlightsCtrl.text.trim().split(',').map((e) => e.trim()).toList(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Successfully added!')),
      );

      nameCtrl.clear();
      locationCtrl.clear();
      priceCtrl.clear();
      descCtrl.clear();
      detailsCtrl.clear();
      facilitiesCtrl.clear();
      imageUrlsCtrl.clear();
      dateCtrl.clear();
      timeCtrl.clear();
      highlightsCtrl.clear();
      setState(() => _selectedType = null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to add: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Admin Panel'), backgroundColor: Colors.deepOrange),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              hint: const Text('Select Type to Add'),
              onChanged: (value) => setState(() => _selectedType = value),
              items: const [
                DropdownMenuItem(value: 'hotel', child: Text('Hotel')),
                DropdownMenuItem(value: 'event', child: Text('Event')),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            const SizedBox(height: 24),
            if (_selectedType != null)
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildField(nameCtrl, _selectedType == 'hotel' ? 'Hotel Name' : 'Event Name'),
                      _buildField(locationCtrl, 'Location'),
                      _buildField(priceCtrl, 'Price (₪)', keyboardType: TextInputType.number),
                      _buildField(descCtrl, 'Description', maxLines: 2),
                      if (_selectedType == 'hotel') ...[
                        _buildField(detailsCtrl, 'Details', maxLines: 3),
                        _buildField(facilitiesCtrl, 'Facilities (comma separated)'),
                        _buildField(imageUrlsCtrl, 'Image URLs (comma separated)'),
                      ],
                      if (_selectedType == 'event') ...[
                        _buildField(imageUrlsCtrl, 'Main Image URL'),
                        _buildField(dateCtrl, 'Date (yyyy-MM-dd)'),
                        _buildField(timeCtrl, 'Time'),
                        _buildField(highlightsCtrl, 'Highlights (comma separated)'),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Submit', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}