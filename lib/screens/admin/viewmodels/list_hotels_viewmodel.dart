// ViewModel (list_hotels_viewmodel.dart)
import 'package:flutter/material.dart';
import 'package:staypal/models/hotel_model.dart';
import 'package:staypal/services/hotel_service.dart';

class ListHotelsViewModel extends ChangeNotifier {
  final HotelService _hotelService = HotelService();
  List<HotelModel> _hotels = [];
  bool _isLoading = false;
  String? _error;

  List<HotelModel> get hotels => _hotels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchHotels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _hotels = await _hotelService.fetchHotels();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}