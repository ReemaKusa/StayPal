import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestFirestoreScreen extends StatelessWidget {
  const TestFirestoreScreen({super.key});

  Future<String> fetchMessage() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('test')
          .doc('demo')
          .get()
          .timeout(const Duration(seconds: 5));

      print('📄 Document fetched: ${doc.data()}');

      if (doc.exists) {
        return doc.data()?['message'] ?? 'No message field';
      } else {
        return 'No document found';
      }
    } catch (e) {
      print('🔥 Firestore error: $e');
      return 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Test')),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchMessage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text(snapshot.data ?? 'No data');
            }
          },
        ),
      ),
    );
  }
}
