// File: admin_dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:staypal/screens/admin/views/add_hotel_view.dart';
import 'package:staypal/screens/admin/views/list_hotels_view.dart';
import 'package:staypal/screens/admin/views/add_event_view.dart';
import 'package:staypal/screens/admin/views/list_events_view.dart';
import 'package:staypal/screens/admin/views/list_users_view.dart';
import 'package:staypal/screens/admin/views/list_bookings_view.dart';
import 'package:staypal/screens/admin/services/hotel_service.dart';
import 'package:staypal/screens/admin/services/event_service.dart';
import 'package:staypal/screens/admin/services/user_service.dart';
import 'package:staypal/screens/admin/services/booking_service.dart';


class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String selectedPage = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StayPal Admin Panel')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Admin Menu', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                setState(() => selectedPage = 'dashboard');
                Navigator.pop(context);
              },
            ),
            ExpansionTile(
              title: const Text('Hotels'),
              children: [
                ListTile(
                  title: const Text('Add Hotel'),
                  onTap: () {
                    setState(() => selectedPage = 'add_hotel');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('List Hotels'),
                  onTap: () {
                    setState(() => selectedPage = 'list_hotels');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Events'),
              children: [
                ListTile(
                  title: const Text('Add Event'),
                  onTap: () {
                    setState(() => selectedPage = 'add_event');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('List Events'),
                  onTap: () {
                    setState(() => selectedPage = 'list_events');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Users'),
              children: [
                ListTile(
                  title: const Text('List Users'),
                  onTap: () {
                    setState(() => selectedPage = 'list_users');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Bookings'),
              children: [
                ListTile(
                  title: const Text('List Bookings'),
                  onTap: () {
                    setState(() => selectedPage = 'list_bookings');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (selectedPage) {
      case 'add_hotel':
        return const AddHotelView();
      case 'list_hotels':
        return const ListHotelsView();
      case 'add_event':
        return const AddEventView();
      case 'list_events':
        return const ListEventsView();
      case 'list_users':
        return const ListUsersView();
      case 'list_bookings':
        return const ListBookingsView();
      case 'dashboard':
      default:
      return FutureBuilder(
        future: Future.wait([
          HotelService().fetchHotels(),
          EventService().fetchEvents(),
          UserService().fetchUsers(),
          BookingService().fetchBookingCount(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final hotels = snapshot.data![0];
          final events = snapshot.data![1];
          final users = snapshot.data![2];
          final bookingCount = snapshot.data![3];

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dashboard Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildStatCard('Total Hotels', hotels.length.toString(), Icons.hotel, Colors.blue),
                    const SizedBox(width: 16),
                    _buildStatCard('Total Events', events.length.toString(), Icons.event, Colors.deepOrange),
                    const SizedBox(width: 16),
                    _buildStatCard('Total Users', users.length.toString(), Icons.person, Colors.green),
                    const SizedBox(width: 16),
                    _buildStatCard('Total Bookings', bookingCount.toString(), Icons.book_online, Colors.purple),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Upcoming Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...events.take(3).map<Widget>((event) {
                  return ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(event.name),
                    subtitle: Text(event.date?.toLocal().toString().split(" ")[0] ?? 'No Date'),
                  );
                }).toList(),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildStatCard(String label, String count, IconData icon, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}