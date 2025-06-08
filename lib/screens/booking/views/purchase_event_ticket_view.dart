import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/event_model.dart';
import 'package:staypal/models/event_ticket_model.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/widgets/visa_card.dart';

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
  bool isEventExpired = false;
  bool hasCard = false;
  bool limitExceeded = false;
  bool showCardDetails = false;

  List<Map<String, dynamic>> userCards = [];
  Map<String, dynamic>? selectedCard;
  bool showCardPreview = false;

  @override
  void initState() {
    super.initState();
    quantity = widget.ticketCount;
    _loadUserLimit();
    _checkEventDate();
    _loadUserCards();

    // 👇 Preload Visa image
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/images/visa.png'), context);
      precacheImage(const AssetImage('assets/images/success.svg'), context);


    });
  }

  void _checkEventDate() {
    final now = DateTime.now();
    setState(() {
      isEventExpired = now.isAfter(widget.event.date);
    });
  }

  Future<void> _loadUserCards() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cardSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cards')
        .get();

    if (cardSnapshot.docs.isNotEmpty) {
      setState(() {
        userCards = cardSnapshot.docs.map((doc) => doc.data()).toList();
        selectedCard = userCards.first;
        hasCard = true;
      });
    }
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
      limitExceeded = quantity > remainingUserLimit;
      if (quantity > remainingUserLimit) {
        quantity = remainingUserLimit;
      }
    });
  }

  Future<void> _simulatePurchase(int available) async {
    if (isEventExpired || limitExceeded || !hasCard || selectedCard == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

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
      final bookingReference = 'REF-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

      final ticket = EventTicketModel(
        ticketId: ticketRef.id,
        userId: user.uid,
        eventId: widget.event.eventId,
        purchaseDate: DateTime.now(),
        quantity: quantity,
        totalPrice: total,
        bookingReference: bookingReference,
      );

      await ticketRef.set(ticket.toMap());

      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/success.png', height: 120),
              const SizedBox(height: 20),
              const Text(
                'Thank you for your purchase!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Your booking reference: $bookingReference',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Done', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );

      await FirebaseFirestore.instance
          .collection('event')
          .doc(widget.event.eventId)
          .update({
        'ticketsSold': FieldValue.increment(quantity),
      });


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase failed: $e')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  Widget _buildCardInfo() {
    if (!hasCard || userCards.isEmpty || selectedCard == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.credit_card_off, color: Colors.red),
            const SizedBox(width: 8),
            Text('No payment method added', style: TextStyle(color: Colors.red[800])),
          ],
        ),
      );
    }

    final selectedCardNumber = selectedCard!['number']?.toString() ?? '';
    final last4 = selectedCardNumber.length > 4
        ? selectedCardNumber.substring(selectedCardNumber.length - 4)
        : selectedCardNumber;
    final maskedSelected = '•••• •••• •••• $last4';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<Map<String, dynamic>>(
          value: selectedCard,
          isExpanded: true,
          underline: const SizedBox(),
          onChanged: (Map<String, dynamic>? newCard) {
            setState(() {
              if (selectedCard == newCard) {
                showCardDetails = !showCardDetails;
              } else {
                selectedCard = newCard;
                showCardDetails = true;
              }
            });
          },
          items: userCards.map((card) {
            final cardNumber = card['number']?.toString() ?? '';
            final last4 = cardNumber.length > 4
                ? cardNumber.substring(cardNumber.length - 4)
                : cardNumber;
            final masked = '•••• •••• •••• $last4';

            return DropdownMenuItem<Map<String, dynamic>>(
              value: card,
              child: Row(
                children: [
                  const Icon(Icons.credit_card, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(masked),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        if (showCardDetails && selectedCard != null)
          PaymentCardWidget(
            cardNumber: selectedCard!['number'] ?? '',
            cardHolder: selectedCard!['cardholder'] ?? '',
            expiryDate: selectedCard!['expiry'] ?? '',
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = widget.event;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('event')
          .doc(widget.event.eventId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final ticketsSold = (data['ticketsSold'] as int?) ?? 0;
        final limit = (data['limite'] as int?) ?? 0;
        final available = (limit - ticketsSold).clamp(0, limit);
        final maxSelectable = [available, remainingUserLimit, 10].reduce((a, b) => a < b ? a : b);
        if (maxSelectable == 0 && quantity != 1) quantity = 1;

        return Scaffold(
          appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PAYMENT METHOD', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                _buildCardInfo(),
                const SizedBox(height: 20),
                Text('TICKET QUANTITY', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Price per ticket', style: theme.textTheme.bodyMedium),
                            Text('₪${event.price.toStringAsFixed(2)}', style: theme.textTheme.bodyMedium),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quantity', style: theme.textTheme.bodyMedium),
                            DropdownButton<int>(
                              value: quantity,
                              onChanged: isEventExpired || limitExceeded
                                  ? null
                                  : (val) => setState(() {
                                quantity = val!;
                                limitExceeded = quantity > remainingUserLimit;
                              }),
                              items: maxSelectable > 0
                                  ? List.generate(
                                maxSelectable,
                                    (index) => DropdownMenuItem(
                                  value: index + 1,
                                  child: Text('${index + 1}'),
                                ),
                              )
                                  : [],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Available', style: theme.textTheme.bodySmall),
                            Text('$available', style: theme.textTheme.bodySmall),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Your limit', style: theme.textTheme.bodySmall),
                            Text(
                              '$remainingUserLimit',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: limitExceeded ? Colors.red : null,
                                fontWeight: limitExceeded ? FontWeight.bold : null,
                              ),
                            ),
                          ],
                        ),
                        if (limitExceeded) ...[
                          const SizedBox(height: 8),
                          Text(
                            'You have reached your ticket limit for this event',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TOTAL', style: theme.textTheme.titleMedium),
                        Text(
                          '₪${(event.price * quantity).toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isEventExpired || isProcessing || !hasCard || limitExceeded
                        ? null
                        : () => _simulatePurchase(available),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: isEventExpired || !hasCard || limitExceeded
                          ? Colors.grey
                          : AppColors.primary,
                    ),
                    child: isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      isEventExpired
                          ? 'Event has ended'
                          : !hasCard
                          ? 'Add payment method'
                          : limitExceeded
                          ? 'Ticket limit reached'
                          : 'Pay ₪${(event.price * quantity).toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
