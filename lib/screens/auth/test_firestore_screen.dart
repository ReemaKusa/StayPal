import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestFirestoreScreen extends StatelessWidget {
  const TestFirestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Connection Test')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('test').doc('demo').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No document found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          return Center(
            child: Text(
              data['message'] ?? 'No message',
              style: const TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
