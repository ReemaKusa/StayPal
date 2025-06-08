import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/event_model.dart';
import 'package:staypal/screens/admin/services/event_service.dart';

class EditEventViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  final highlightsCtrl = TextEditingController();
  final availableTicketsCtrl = TextEditingController();

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

  String? selectedLocation;
  bool isFavorite = false;
  bool isAdmin = false;
  List<Map<String, dynamic>> organizers = [];
  String? selectedOrganizerId;
  bool isLoading = true;
  String? eventId;

  final _eventService = EventService();

  void initialize(EventModel event) async {
    eventId = event.eventId;
    nameCtrl.text = event.name;
    priceCtrl.text = event.price.toString();
    descriptionCtrl.text = event.description;
    detailsCtrl.text = event.details;
    imageCtrl.text = event.images.join(', ');
    selectedLocation = event.location;
    dateCtrl.text = event.date.toIso8601String().substring(0, 10);
    timeCtrl.text = event.time;
    highlightsCtrl.text = event.highlights.join(', ');
    isFavorite = event.isFavorite;
    selectedOrganizerId = event.organizerId;
    availableTicketsCtrl.text = event.limite.toString();

    await _checkAdminAndFetchOrganizers();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _checkAdminAndFetchOrganizers() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists && userDoc.data()?['role'] == 'admin') {
      isAdmin = true;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'event_organizer')
          .get();

      organizers = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          'name': data['fullName']?.toString() ?? 'Unnamed',
        };
      }).toList();
    }
  }

  List<Widget> buildFormFields(BuildContext context) {
    return [
      TextFormField(
        controller: nameCtrl,
        decoration: const InputDecoration(
          labelText: 'Event Name',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value!.isEmpty ? 'Enter event name' : null,
      ),
      const SizedBox(height: AppSpacing.medium),
      DropdownButtonFormField<String>(
        value: selectedLocation,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: 'City',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: AppColors.white,
        ),
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        onChanged: (String? newValue) {
          selectedLocation = newValue;
          notifyListeners();
        },
        items:
            cities.map((city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city, overflow: TextOverflow.ellipsis, maxLines: 1),
              );
            }).toList(),
        validator:
            (value) => value == null || value.isEmpty ? 'Select a city' : null,
      ),

      const SizedBox(height: AppSpacing.medium),
      TextFormField(
        controller: priceCtrl,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Price',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value!.isEmpty ? 'Enter price' : null,
      ),
      const SizedBox(height: AppSpacing.medium),
      TextFormField(
        controller: availableTicketsCtrl,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Available Tickets',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value!.isEmpty ? 'Enter available tickets' : null,
      ),
      const SizedBox(height: AppSpacing.medium),
      TextFormField(
        controller: descriptionCtrl,
        maxLines: 2,
        decoration: const InputDecoration(
          labelText: 'Short Description',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: AppSpacing.medium),
      TextFormField(
        controller: detailsCtrl,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Detailed Info',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: AppSpacing.medium),
      TextFormField(
        controller: imageCtrl,
        decoration: const InputDecoration(
          labelText: 'Image URL',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: AppSpacing.medium),
      TextFormField(
        controller: dateCtrl,
        decoration: const InputDecoration(
          labelText: 'Date (yyyy-MM-dd)',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: AppSpacing.medium),
      TextFormField(
        controller: timeCtrl,
        decoration: const InputDecoration(
          labelText: 'Time (e.g. 7:00pm)',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: AppSpacing.medium),
      TextFormField(
        controller: highlightsCtrl,
        decoration: const InputDecoration(
          labelText: 'Highlights (comma separated)',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: AppSpacing.medium),
      SwitchListTile(
        title: const Text('Is Favorite?'),
        value: isFavorite,
        onChanged: (val) {
          isFavorite = val;
          notifyListeners();
        },
      ),
      if (isAdmin)
        Column(
          children: [
            const SizedBox(height: AppSpacing.medium),
            DropdownButtonFormField<String>(
              value: selectedOrganizerId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Assigned Organizer',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AppColors.white,
              ),
              items: organizers.map((org) {
                return DropdownMenuItem<String>(
                  value: org['uid'],
                  child: Text(org['name'] ?? 'Unnamed'),
                );
              }).toList(),
              onChanged: (val) => selectedOrganizerId = val,
              validator: (val) => val == null ? 'Select an organizer' : null,
            ),
          ],
        ),
    ];
  }

  Future<void> updateEvent(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final event = EventModel(
        eventId: eventId ?? '',
        name: nameCtrl.text,
        location: selectedLocation ?? '',
        price: double.tryParse(priceCtrl.text) ?? 0.0,
        description: descriptionCtrl.text,
        details: detailsCtrl.text,
        images: imageCtrl.text
            .split(',')
            .map((url) => url.trim())
            .where((url) => url.isNotEmpty)
            .toList(),        date: DateTime.tryParse(dateCtrl.text) ?? DateTime.now(),
        time: timeCtrl.text.trim(),
        highlights: highlightsCtrl.text.split(',').map((e) => e.trim()).toList(),
        limite: int.tryParse(availableTicketsCtrl.text) ?? 0,
        ticketsSold: 0,
        rating: 0.0,
        isFavorite: isFavorite,
        createdAt: DateTime.now(),
        organizerId: selectedOrganizerId ?? '',
      );

      if (eventId != null) {
        await _eventService.updateEvent(eventId!, event);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event updated successfully')),
          );
          Navigator.pop(context);
        }
      }
    }
  }

  Future<void> deleteEvent(BuildContext context) async {
    final confirm = await showDialog<bool>(
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
                      fontSize: AppFontSizes.subtitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  const Text(
                    'Are you sure you want to delete this event?\nThis cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: AppSpacing.large),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: AppPadding.buttonVertical,
                            ),
                            side: BorderSide(color: AppColors.greyTransparent),
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppBorderRadius.card,
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: AppPadding.buttonVertical,
                            ),
                            backgroundColor: AppColors.white,
                            side: BorderSide(color: AppColors.greyTransparent),


                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppBorderRadius.card,
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
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
    );

    if (confirm == true) {
      await _eventService.deleteEvent(selectedOrganizerId!);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Event deleted')));
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    descriptionCtrl.dispose();
    detailsCtrl.dispose();
    imageCtrl.dispose();
    dateCtrl.dispose();
    timeCtrl.dispose();
    highlightsCtrl.dispose();
    super.dispose();
  }
}
