import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:staypal/utils/dialogs_logout.dart';
import 'dart:math' as math;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  String selectedPage = 'dashboard';
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOutExpo,
    );

    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

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
                colors: [
                 
                  Color.fromARGB(255, 252, 116, 75),
                   Color.fromARGB(255, 209, 91, 54),
                ],
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
            onTap: () => DialogsUtil.showLogoutDialog(context),
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
              return Center(child: Text('Error: ${snapshot.error}'));
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
                    'Dashboard Analytics',
                    style: TextStyle(
                      fontSize: AppFontSizes.title,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildMainAnalyticsChart(
                    users.length,
                    events.length,
                    hotels.length,
                    bookingCount,
                  ),
                  const SizedBox(height: 32),
                  _buildMetricCards(
                    users.length,
                    events.length,
                    hotels.length,
                    bookingCount,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: AppFontSizes.subtitle,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
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
                                color: AppColors.primary,
                              ),
                              title: Text(
                                event.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                event.date?.toLocal().toString().split(
                                      " ",
                                    )[0] ??
                                    'No Date',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grey,
                                ),
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

  Widget _buildMainAnalyticsChart(
    int users,
    int events,
    int hotels,
    int bookings,
  ) {
    final total = users + events + hotels + bookings;
    final List<ChartData> chartData = [
      ChartData(
        'Users',
        users,
        const Color.fromARGB(255, 255, 247, 98),
        users / total,
      ),
      ChartData('Events', events, Color.fromARGB(255, 126, 231, 221), events / total),
      ChartData(
        'Hotels',
        hotels,
        Color.fromARGB(255, 106, 194, 245),
        hotels / total,
      ),
      ChartData(
        'Bookings',
        bookings,
        const Color.fromARGB(255, 252, 124, 60),
        bookings / total,
      ),
    ];
    return Container(
      height: 300,
      padding: const EdgeInsets.all(AppPadding.screenPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyTransparent,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child:
                      _animationController != null
                          ? AnimatedBuilder(
                            animation: _animation!,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: DonutChartPainter(
                                  chartData,
                                  _animation!.value,
                                ),
                                child: const SizedBox.expand(),
                              );
                            },
                          )
                          : const SizedBox(width: 16, height: 16),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        chartData.map((data) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 23,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: data.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    data.label,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCards(int users, int events, int hotels, int bookings) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final metrics = [
              [
                'Active Users',
                users,
                Icons.person,
                const Color.fromARGB(255, 247, 214, 0),
                0,
              ],
              ['Events', events, Icons.event, Color.fromARGB(255, 78, 220, 206), 200],
              [
                'Hotels',
                hotels,
                Icons.hotel,
                const Color.fromARGB(255, 25, 148, 225),
                400,
              ],
              [
                'All Bookings',
                bookings,
                Icons.book_online,
                const Color.fromARGB(255, 249, 95, 19),
                600,
              ],
            ];

            final m = metrics[index];
            return _buildAnimatedMetricCard(
              m[0] as String,
              m[1] as int,
              m[2] as IconData,
              m[3] as Color,
              m[4] as int,
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedMetricCard(
    String label,
    int value,
    IconData icon,
    Color color,
    int delay,
  ) {
    if (_animationController == null || _animation == null) {
      return _buildStaticMetricCard(label, value, icon, color);
    }

    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        double animationValue = math.max(
          0,
          (_animation!.value * 1000 - delay) / 200,
        );
        animationValue = math.min(1, animationValue);

        return Transform.scale(
          scale: 0.8 + (0.2 * animationValue),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppBorderRadius.card),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyTransparent,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppPadding.containerPadding),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  (value * animationValue).round().toString(),
                  style: TextStyle(
                    fontSize: AppFontSizes.title,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: AppFontSizes.bottonfont,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStaticMetricCard(
    String label,
    int value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppPadding.containerPadding),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String label;
  final int value;
  final Color color;
  final double percentage;

  ChartData(this.label, this.value, this.color, this.percentage);
}

class DonutChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double animationValue;

  DonutChartPainter(this.data, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = math.min(size.width, size.height) / 2.5;

    final strokeWidth = 36.0;

    double rotation = 0.0;
    double startAngle = -math.pi / 2 + rotation;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = 2 * math.pi * data[i].percentage * animationValue;

      final paint =
          Paint()
            ..color = data[i].color
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      final linePaint =
          Paint()
            ..color = Colors.white
            ..strokeWidth = 2.0;

      final x = center.dx + radius * math.cos(startAngle);
      final y = center.dy + radius * math.sin(startAngle);
      canvas.drawLine(center, Offset(x, y), linePaint);

      startAngle += sweepAngle;
    }

    canvas.drawCircle(
      center,
      radius - strokeWidth / 1.5,
      Paint()..color = Colors.white,
    );

    final centerText = TextSpan(
      text: 'Analytics',
      style: const TextStyle(
        fontSize: AppFontSizes.subtitle,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
    final centerTextPainter = TextPainter(
      text: centerText,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    centerTextPainter.layout();
    centerTextPainter.paint(
      canvas,
      Offset(
        center.dx - centerTextPainter.width / 2,
        center.dy - centerTextPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
