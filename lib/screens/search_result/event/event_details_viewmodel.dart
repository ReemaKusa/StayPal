import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventDetailsViewModel {
  final Map<String, dynamic> event;
  final String eventId;
  final stateNotifier = ValueNotifier<EventDetailsState>(EventDetailsState());

  EventDetailsViewModel({
    required this.event,
    required this.eventId,
  });

  void init(BuildContext context) {
    final eventPrice = event['price'] is num ? (event['price'] as num).toDouble() : 0.0;
    stateNotifier.value = stateNotifier.value.copyWith(
      totalPrice: eventPrice,
      images: event['images'] is List ? event['images'] as List : [],
      context: context,
    );
    _getCurrentUser();
    _checkEventDate();
  }

  Future<void> _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      stateNotifier.value = stateNotifier.value.copyWith(currentUserId: user.uid);
    }
  }

  void _checkEventDate() {
    final date = event['date'];
    if (date == null) return;

    DateTime eventDate;
    if (date is Timestamp) {
      eventDate = date.toDate();
    } else if (date is String) {
      try {
        eventDate = DateTime.parse(date);
      } catch (e) {
        return;
      }
    } else {
      return;
    }

    final now = DateTime.now();
    stateNotifier.value = stateNotifier.value.copyWith(isEventExpired: eventDate.isBefore(now));
  }

  String formatDate(dynamic date) {
    if (date == null) return 'No Date';
    if (date is Timestamp) {
      return DateFormat('yyyy-MM-dd').format(date.toDate());
    }
    if (date is String) return date;
    return 'Invalid Date';
  }

  void shareOptions() {
    final name = event['name'] ?? 'Event';
    final location = event['location'] ?? 'Unknown location';
    final date = formatDate(event['date']);
    final description = event['description'] ?? '';
    final price = event['price']?.toString() ?? '';

    final message = '''
🎉 Check out this event: $name
📍 Location: $location
📅 Date: $date
💸 Price: $price ₪
📄 Description: $description

Join me for a great time! 🥳
''';

    final context = stateNotifier.value.context;
    if (context == null) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 10,
          children: [
            ListTile(
              leading: const Icon(Icons.ios_share, color: Colors.black),
              title: const Text('Share via system'),
              onTap: () {
                Share.share(message);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
              title: const Text('WhatsApp'),
              onTap: () {
                final uri = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(message)}");
                _launchUrl(uri);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
              title: const Text('Facebook'),
              onTap: () {
                final uri = Uri.parse("https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(message)}");
                _launchUrl(uri);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.telegram, color: Colors.blueAccent),
              title: const Text('Telegram'),
              onTap: () {
                final uri = Uri.parse("https://t.me/share/url?url=${Uri.encodeComponent(message)}");
                _launchUrl(uri);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.xTwitter, color: Colors.black),
              title: const Text('Twitter'),
              onTap: () {
                final uri = Uri.parse("https://twitter.com/intent/tweet?text=${Uri.encodeComponent(message)}");
                _launchUrl(uri);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    final context = stateNotifier.value.context;
    if (context == null) return;

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch link")),
      );
    }
  }

  void onItemTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/wishlist');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  void updateTicketCount(int newCount) {
    final eventPrice = event['price'] is num ? (event['price'] as num).toDouble() : 0.0;
    stateNotifier.value = stateNotifier.value.copyWith(
      ticketCount: newCount,
      totalPrice: eventPrice * newCount,
    );
  }
}

class EventDetailsState {
  final int ticketCount;
  final double totalPrice;
  final String? currentUserId;
  final bool isEventExpired;
  final List<dynamic> images;
  final BuildContext? context;

  EventDetailsState({
    this.ticketCount = 1,
    this.totalPrice = 0,
    this.currentUserId,
    this.isEventExpired = false,
    this.images = const [],
    this.context,
  });

  EventDetailsState copyWith({
    int? ticketCount,
    double? totalPrice,
    String? currentUserId,
    bool? isEventExpired,
    List<dynamic>? images,
    BuildContext? context,
  }) {
    return EventDetailsState(
      ticketCount: ticketCount ?? this.ticketCount,
      totalPrice: totalPrice ?? this.totalPrice,
      currentUserId: currentUserId ?? this.currentUserId,
      isEventExpired: isEventExpired ?? this.isEventExpired,
      images: images ?? this.images,
      context: context ?? this.context,
    );
  }
}