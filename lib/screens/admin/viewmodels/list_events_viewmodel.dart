import 'package:flutter/material.dart';
import 'package:staypal/models/event_model.dart';
import 'package:staypal/screens/admin/services/event_service.dart';

class ListEventsViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();
  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _error;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _eventService.fetchEvents();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
