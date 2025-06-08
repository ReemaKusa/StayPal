import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/admin/services/hotel_service.dart';
import 'package:staypal/screens/admin/services/event_service.dart';
import 'package:staypal/screens/admin/services/user_service.dart';
import 'package:staypal/screens/admin/services/booking_service.dart';
import 'package:staypal/screens/admin/views/add_hotel_view.dart';
import 'package:staypal/screens/admin/views/list_hotels_view.dart';
import 'package:staypal/screens/admin/views/add_event_view.dart';
import 'package:staypal/screens/admin/views/list_events_view.dart';
import 'package:staypal/screens/admin/views/list_users_view.dart';
import 'package:staypal/screens/admin/views/list_bookings_view.dart';
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
        elevation: 0,
        title: const Text(
          'StayPal Admin Panel',
          style: TextStyle(
            fontSize: AppFontSizes.title,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.primary),
        automaticallyImplyLeading: true,
      ),
      drawer: _buildDrawer(),
      body: _buildContent(),
      backgroundColor: AppColors.white,
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
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
          _buildDrawerTile('Dashboard', () => _selectPage('dashboard')),
          _buildExpansionTile('Hotels', [
            _buildDrawerTile('Add Hotel', () => _selectPage('add_hotel')),
            _buildDrawerTile('List Hotels', () => _selectPage('list_hotels')),
          ]),
          _buildExpansionTile('Events', [
            _buildDrawerTile('Add Event', () => _selectPage('add_event')),
            _buildDrawerTile('List Events', () => _selectPage('list_events')),
          ]),
          _buildExpansionTile('Users', [
            _buildDrawerTile('List Users', () => _selectPage('list_users')),
          ]),
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
    );
  }

  void _selectPage(String page) {
    setState(() => selectedPage = page);
    Navigator.pop(context);
  }

  Widget _buildDrawerTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: AppIconSizes.smallIcon,
        color: AppColors.primary,
      ),
      onTap: onTap,
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
        return const ListAllBookingsView();
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
              return Center(child: Text('Error: \${snapshot.error}'));
            }

            final hotels = snapshot.data![0];
            final events = snapshot.data![1];
            final users = snapshot.data![2];
            final bookingCount = snapshot.data![3];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard Overview',
                    style: TextStyle(
                      fontSize: AppFontSizes.title,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBlock(
                          'Users',
                          users.length.toString(),
                          Icons.person,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBlock(
                          'Events',
                          events.length.toString(),
                          Icons.event,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBlock(
                          'Hotels Filled',
                          '\${(hotels.length / 100 * 100).toStringAsFixed(1)}%',
                          Icons.hotel,
                          isCircular: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildLargeStatCard(
                    'Total Bookings',
                    bookingCount.toString(),
                    Icons.bar_chart,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children:
                        events.take(3).map<Widget>((event) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(
                                AppBorderRadius.card,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.greyTransparent,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.calendar_today,
                                color: Colors.black87,
                              ),
                              title: Text(event.name),
                              subtitle: Text(
                                event.date?.toLocal().toString().split(
                                      " ",
                                    )[0] ??
                                    'No Date',
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            );
          },
        );
    }
  }

  Widget _buildStatBlock(
  String label,
  String value,
  IconData icon, {
  bool isCircular = false,
}) {
  return Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppBorderRadius.card),
    ),
    shadowColor: AppColors.white,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (isCircular)
            Icon(Icons.hotel, size: 40, color: AppColors.primary)
          else ...[
            Icon(icon, size: 28, color: AppColors.primary),
            const SizedBox(height: 15),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          const SizedBox(height: 15),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildLargeStatCard(String label, String count, IconData icon) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 28, color: AppColors.primary),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              count,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
