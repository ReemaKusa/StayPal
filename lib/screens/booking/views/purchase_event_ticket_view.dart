// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:staypal/models/event_model.dart';
// import 'package:staypal/models/event_ticket_model.dart';
//
// class PurchaseEventTicketView extends StatefulWidget {
//   final EventModel event;
//   final int ticketCount;
//
//   const PurchaseEventTicketView({
//     super.key,
//     required this.event,
//     required this.ticketCount,
//   });
//
//   @override
//   State<PurchaseEventTicketView> createState() => _PurchaseEventTicketViewState();
// }
//
// class _PurchaseEventTicketViewState extends State<PurchaseEventTicketView> {
//   late int quantity;
//   bool isProcessing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     quantity = widget.ticketCount;
//   }
//
//   Future<void> _simulatePurchase() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//     final cardSnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('cards')
//         .limit(1)
//         .get();
//
//     final hasCard = cardSnapshot.docs.isNotEmpty;
//
//     if (!hasCard) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('You need to add a credit card to purchase.')),
//       );
//       return;
//     }
//
//     final total = widget.event.price * quantity;
//     setState(() => isProcessing = true);
//
//     await FirebaseFirestore.instance.collection('eventTickets').add(
//       EventTicketModel(
//         ticketId: '',
//         userId: user.uid,
//         eventId: widget.event.eventId,
//         purchaseDate: DateTime.now(),
//         quantity: quantity,
//         totalPrice: total,
//       ).toMap(),
//     );
//
//     await FirebaseFirestore.instance.collection('event').doc(widget.event.eventId).update({
//       'ticketsSold': widget.event.ticketsSold + quantity,
//     });
//
//     setState(() => isProcessing = false);
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Ticket purchased!')),
//       );
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final event = widget.event;
//     final available = event.availableTickets;
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Buy Ticket')),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(event.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Text(event.location),
//             const SizedBox(height: 8),
//             Text('₪${event.price.toStringAsFixed(2)} per ticket'),
//             const SizedBox(height: 8),
//             Text('Available tickets: $available'),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 const Text('Quantity:', style: TextStyle(fontSize: 16)),
//                 const SizedBox(width: 16),
//                 DropdownButton<int>(
//                   value: quantity,
//                   onChanged: (val) => setState(() => quantity = val!),
//                   items: List.generate(
//                     available.clamp(1, 10),
//                         (index) => DropdownMenuItem(value: index + 1, child: Text('${index + 1}')),
//                   ),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: isProcessing ? null : _simulatePurchase,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   backgroundColor: Colors.deepOrange,
//                 ),
//                 child: isProcessing
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text('Pay ₪${(event.price * quantity).toStringAsFixed(2)}'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/event_model.dart';
import 'package:staypal/models/event_ticket_model.dart';

class PurchaseEventTicketView extends StatefulWidget {
  final EventModel event;
  final int ticketCount;

  const PurchaseEventTicketView({
    super.key,
    required this.event,
    required this.ticketCount,
  });

  @override
  State<PurchaseEventTicketView> createState() => _PurchaseEventTicketViewState();
}

class _PurchaseEventTicketViewState extends State<PurchaseEventTicketView> {
  late int quantity;
  bool isProcessing = false;
  int remainingUserLimit = 5;

  @override
  void initState() {
    super.initState();
    quantity = widget.ticketCount;
    _loadUserLimit();
  }

  Future<void> _loadUserLimit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final pastPurchases = await FirebaseFirestore.instance
        .collection('eventTickets')
        .where('userId', isEqualTo: user.uid)
        .where('eventId', isEqualTo: widget.event.eventId)
        .get();

    int bought = 0;
    for (var doc in pastPurchases.docs) {
      final data = doc.data();
      if (data['quantity'] is int) {
        bought += data['quantity'] as int;
      }
    }

    setState(() {
      remainingUserLimit = (5 - bought).clamp(0, 5);
      if (quantity > remainingUserLimit) {
        quantity = remainingUserLimit;
      }
    });
  }

  Future<void> _simulatePurchase(int available) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cardSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cards')
        .limit(1)
        .get();

    final hasCard = cardSnapshot.docs.isNotEmpty;
    if (!hasCard) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to add a credit card to purchase.')),
      );
      return;
    }

    if (quantity > remainingUserLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only buy $remainingUserLimit more ticket(s) for this event.')),
      );
      return;
    }

    if (quantity > available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough tickets available.')),
      );
      return;
    }

    final total = widget.event.price * quantity;
    setState(() => isProcessing = true);

    try {
      final ticketRef = FirebaseFirestore.instance.collection('eventTickets').doc();
      final bookingRef = 'REF-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      final bookingReference = 'REF-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

      final ticket = EventTicketModel(
          ticketId: ticketRef.id,
          userId: user.uid,
          eventId: widget.event.eventId,
          purchaseDate: DateTime.now(),
          quantity: quantity,
          totalPrice: total,
          bookingReference: bookingReference,
      );// ✅ Correct name

      await ticketRef.set(ticket.toMap());

      await FirebaseFirestore.instance
          .collection('event')
          .doc(widget.event.eventId)
          .update({
        'ticketsSold': FieldValue.increment(quantity),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket purchased successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase failed: $e')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(title: const Text('Buy Ticket')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('event')
            .doc(widget.event.eventId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final available = (data['limite'] ?? 0) - (data['ticketsSold'] ?? 0);
          final maxSelectable = [available, remainingUserLimit, 10].reduce((a, b) => a < b ? a : b);

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(event.location),
                const SizedBox(height: 8),
                Text('₪${event.price.toStringAsFixed(2)} per ticket'),
                const SizedBox(height: 8),
                Text('Available tickets: $available'),
                const SizedBox(height: 8),
                Text('Your limit left: $remainingUserLimit'),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text('Quantity:', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 16),
                    DropdownButton<int>(
                      value: quantity,
                      onChanged: (val) => setState(() => quantity = val!),
                      items: List.generate(
                        maxSelectable,
                            (index) => DropdownMenuItem(value: index + 1, child: Text('${index + 1}')),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isProcessing ? null : () => _simulatePurchase(available),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Pay ₪${(event.price * quantity).toStringAsFixed(2)}'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}