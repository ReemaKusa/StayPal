import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
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
import 'package:staypal/screens/auth/viewmodels/logout_viewmodel.dart';

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
      appBar: AppBar(
        title: Text(
          'StayPal Admin Panel',
          style: TextStyle(
            fontSize: AppFontSizes.title,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.white,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Colors.deepOrangeAccent],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Admin Menu',
                  style: TextStyle(
                    fontSize: AppFontSizes.title,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.medium),

            _buildDrawerTile('Dashboard', () => _selectPage('dashboard')),
            const SizedBox(height: AppSpacing.medium),
            _buildExpansionTile('Hotels', [
              _buildDrawerTile('Add Hotel', () => _selectPage('add_hotel')),
              _buildDrawerTile('List Hotels', () => _selectPage('list_hotels')),
            ]),
            const SizedBox(height: AppSpacing.medium),
            _buildExpansionTile('Events', [
              _buildDrawerTile('Add Event', () => _selectPage('add_event')),
              _buildDrawerTile('List Events', () => _selectPage('list_events')),
            ]),
            const SizedBox(height: AppSpacing.medium),
            _buildExpansionTile('Users', [
              _buildDrawerTile('List Users', () => _selectPage('list_users')),
            ]),
            const SizedBox(height: AppSpacing.medium),
            _buildExpansionTile('Bookings', [
              _buildDrawerTile(
                'List Bookings',
                () => _selectPage('list_bookings'),
              ),
            ]),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primary),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                LogoutViewModel().logout(context);
              },
            ),
          ],
        ),
      ),
      body: _buildContent(),
      backgroundColor: AppColors.white,
    );
  }

  void _selectPage(String page) {
    setState(() => selectedPage = page);
    Navigator.pop(context);
  }

  Widget _buildDrawerTile(String title, VoidCallback onTap) {
    return Container(
      color: AppColors.white,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: AppIconSizes.smallIcon,
          color: AppColors.primary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildExpansionTile(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: children,

      iconColor: AppColors.primary,
      collapsedIconColor: AppColors.primary,
      collapsedBackgroundColor: AppColors.white,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.card),
        side: const BorderSide(color: AppColors.greyTransparent),
      ),
      tilePadding: const EdgeInsets.symmetric(
        horizontal: AppPadding.formHorizontal,
      ),
      childrenPadding: const EdgeInsets.only(left: AppPadding.iconPadding),
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
            return Center(child: Text('Error: ${snapshot.error}')); // ✅ fixed here
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

  Widget _buildStatCard(
    String label,
    String count,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.card),
        ),
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(AppPadding.containerPadding),
          child: Column(
            children: [
              Icon(icon, size: AppIconSizes.smallIcon, color: color),
              const SizedBox(height: AppSpacing.small),
              Text(
                count,
                style: const TextStyle(
                  fontSize: AppFontSizes.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
