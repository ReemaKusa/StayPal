import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/event_model.dart';
import 'package:staypal/models/event_ticket_model.dart';

class PurchaseEventTicketViewModel extends ChangeNotifier {
  final EventModel event;
  final int initialTicketCount;

  PurchaseEventTicketViewModel({
    required this.event,
    required this.initialTicketCount,
  });

  // State variables
  late int _quantity;
  bool _isProcessing = false;
  int _remainingUserLimit = 5;
  bool _isEventExpired = false;
  bool _hasCard = false;
  bool _limitExceeded = false;
  bool _showCardDetails = false;

  List<Map<String, dynamic>> _userCards = [];
  Map<String, dynamic>? _selectedCard;

  // Getters
  int get quantity => _quantity;
  bool get isProcessing => _isProcessing;
  int get remainingUserLimit => _remainingUserLimit;
  bool get isEventExpired => _isEventExpired;
  bool get hasCard => _hasCard;
  bool get limitExceeded => _limitExceeded;
  bool get showCardDetails => _showCardDetails;
  List<Map<String, dynamic>> get userCards => _userCards;
  Map<String, dynamic>? get selectedCard => _selectedCard;

  // Computed properties
  double get totalPrice => event.price * _quantity;
  String get maskedSelectedCardNumber {
    if (_selectedCard == null) return '';
    final cardNumber = _selectedCard!['number']?.toString() ?? '';
    final last4 = cardNumber.length > 4
        ? cardNumber.substring(cardNumber.length - 4)
        : cardNumber;
    return '•••• •••• •••• $last4';
  }

  bool get canPurchase => !_isEventExpired && !_isProcessing && _hasCard && !_limitExceeded;

  String get buttonText {
    if (_isEventExpired) return 'Event has ended';
    if (!_hasCard) return 'Add payment method';
    if (_limitExceeded) return 'Ticket limit reached';
    return 'Pay ₪${totalPrice.toStringAsFixed(2)}';
  }

  // Initialization
  Future<void> initialize() async {
    _quantity = initialTicketCount;
    _checkEventDate();
    await Future.wait([
      _loadUserLimit(),
      _loadUserCards(),
    ]);
  }

  void _checkEventDate() {
    final now = DateTime.now();
    _isEventExpired = now.isAfter(event.date);
    notifyListeners();
  }

  Future<void> _loadUserCards() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final cardSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cards')
          .get();

      if (cardSnapshot.docs.isNotEmpty) {
        _userCards = cardSnapshot.docs.map((doc) => doc.data()).toList();
        _selectedCard = _userCards.first;
        _hasCard = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user cards: $e');
    }
  }

  Future<void> _loadUserLimit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final pastPurchases = await FirebaseFirestore.instance
          .collection('eventTickets')
          .where('userId', isEqualTo: user.uid)
          .where('eventId', isEqualTo: event.eventId)
          .get();

      int bought = 0;
      for (var doc in pastPurchases.docs) {
        final data = doc.data();
        if (data['quantity'] is int) {
          bought += data['quantity'] as int;
        }
      }

      _remainingUserLimit = (5 - bought).clamp(0, 5);
      _limitExceeded = _quantity > _remainingUserLimit;
      if (_quantity > _remainingUserLimit && _remainingUserLimit > 0) {
        _quantity = _remainingUserLimit;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user limit: $e');
    }
  }

  // Actions
  void updateQuantity(int newQuantity) {
    _quantity = newQuantity;
    _limitExceeded = _quantity > _remainingUserLimit;
    notifyListeners();
  }

  void constrainQuantityToLimit(int maxAllowed) {
    if (_quantity > maxAllowed && maxAllowed > 0) {
      _quantity = maxAllowed;
      _limitExceeded = _quantity > _remainingUserLimit;
      notifyListeners();
    }
  }

  void selectCard(Map<String, dynamic>? newCard) {
    if (_selectedCard == newCard) {
      _showCardDetails = !_showCardDetails;
    } else {
      _selectedCard = newCard;
      _showCardDetails = true;
    }
    notifyListeners();
  }

  void toggleCardDetails() {
    _showCardDetails = !_showCardDetails;
    notifyListeners();
  }

  Future<String?> purchaseTickets(int availableTickets) async {
    if (!canPurchase || _selectedCard == null) return null;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'User not authenticated';

    if (_quantity > availableTickets) {
      return 'Not enough tickets available.';
    }

    _isProcessing = true;
    notifyListeners();

    try {
      final ticketRef = FirebaseFirestore.instance.collection('eventTickets').doc();
      final bookingReference = 'REF-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

      final ticket = EventTicketModel(
        ticketId: ticketRef.id,
        userId: user.uid,
        eventId: event.eventId,
        purchaseDate: DateTime.now(),
        quantity: _quantity,
        totalPrice: totalPrice,
        bookingReference: bookingReference,
      );

      await ticketRef.set(ticket.toMap());

      await FirebaseFirestore.instance
          .collection('event')
          .doc(event.eventId)
          .update({
        'ticketsSold': FieldValue.increment(_quantity),
      });

      return bookingReference; // Success - return booking reference
    } catch (e) {
      return 'Purchase failed: $e';
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  String getMaskedCardNumber(Map<String, dynamic> card) {
    final cardNumber = card['number']?.toString() ?? '';
    final last4 = cardNumber.length > 4
        ? cardNumber.substring(cardNumber.length - 4)
        : cardNumber;
    return '•••• •••• •••• $last4';
  }

  int calculateMaxSelectable(int available) {
    return [available, _remainingUserLimit, 10].reduce((a, b) => a < b ? a : b);
  }

  @override
  void dispose() {
    super.dispose();
  }
}