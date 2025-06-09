import 'package:flutter/material.dart';
import 'package:staypal/services/hotel_service.dart';
import 'package:staypal/services/event_service.dart';
import 'package:staypal/services/user_service.dart';
import 'package:staypal/services/booking_service.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  String _selectedPage = 'dashboard';
  bool _isLoading = false;
  String? _error;

  List<dynamic> _hotels = [];
  List<dynamic> _events = [];
  List<dynamic> _users = [];
  int _bookingCount = 0;

  final HotelService _hotelService = HotelService();
  final EventService _eventService = EventService();
  final UserService _userService = UserService();
  final BookingService _bookingService = BookingService();

  String get selectedPage => _selectedPage;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<dynamic> get hotels => _hotels;
  List<dynamic> get events => _events;
  List<dynamic> get users => _users;
  int get bookingCount => _bookingCount;

  List<dynamic> get upcomingEvents {
    final now = DateTime.now();
    return _events
        .where((event) {
          if (event.date == null) return false;
          return event.date!.isAfter(now);
        })
        .take(3)
        .toList();
  }

  List<ChartData> get chartData {
    final total =
        _users.length + _events.length + _hotels.length + _bookingCount;
    if (total == 0) return [];

    return [
      ChartData(
        'Users',
        _users.length,
        const Color.fromARGB(255, 255, 247, 98),
        _users.length / total,
      ),
      ChartData(
        'Events',
        _events.length,
        const Color.fromARGB(255, 126, 231, 221),
        _events.length / total,
      ),
      ChartData(
        'Hotels',
        _hotels.length,
        const Color.fromARGB(255, 106, 194, 245),
        _hotels.length / total,
      ),
      ChartData(
        'Bookings',
        _bookingCount,
        const Color.fromARGB(255, 252, 124, 60),
        _bookingCount / total,
      ),
    ];
  }

  List<MetricData> get metricData => [
    MetricData(
      'Active Users',
      _users.length,
      Icons.person,
      const Color.fromARGB(255, 247, 214, 0),
      0,
    ),
    MetricData(
      'Events',
      _events.length,
      Icons.event,
      const Color.fromARGB(255, 78, 220, 206),
      200,
    ),
    MetricData(
      'Hotels',
      _hotels.length,
      Icons.hotel,
      const Color.fromARGB(255, 25, 148, 225),
      400,
    ),
    MetricData(
      'All Bookings',
      _bookingCount,
      Icons.book_online,
      const Color.fromARGB(255, 249, 95, 19),
      600,
    ),
  ];

  void selectPage(String page) {
    _selectedPage = page;
    notifyListeners();
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _hotelService.fetchHotels(),
        _eventService.fetchEvents(),
        _userService.fetchUsers(),
        _bookingService.fetchBookingCount(),
      ]);

      _hotels = results[0] as List<dynamic>;
      _events = results[1] as List<dynamic>;
      _users = results[2] as List<dynamic>;
      _bookingCount = results[3] as int;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }
}

class ChartData {
  final String label;
  final int value;
  final Color color;
  final double percentage;

  ChartData(this.label, this.value, this.color, this.percentage);
}

class MetricData {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final int delay;

  MetricData(this.label, this.value, this.icon, this.color, this.delay);
}
