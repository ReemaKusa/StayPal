import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/screens/homePage/views/home_page.dart';
import 'package:staypal/screens/admin/views/admin_dashboard_view.dart';
import 'package:staypal/screens/admin/views/hotel_manager_view.dart';
import 'package:staypal/screens/admin/views/event_organizer_view.dart';

class RoleRouterService {
  Future<Widget> getStartView() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return  HomePage();

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final role = doc.data()?['role'];

    switch (role) {
      case 'admin':
        return const AdminDashboard();
      case 'hotel_manager':
        return const HotelManagerView();
      case 'event_organizer':
        return const EventOrganizerView();
      default:
        return  HomePage();
    }
  }
}