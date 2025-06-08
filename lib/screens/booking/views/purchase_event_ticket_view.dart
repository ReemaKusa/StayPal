import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:staypal/models/event_model.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/widgets/visa_card.dart';
import 'package:staypal/screens/booking/viewmodels/purchase_event_ticket_viewmodel.dart';

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
  late PurchaseEventTicketViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = PurchaseEventTicketViewModel(
      event: widget.event,
      initialTicketCount: widget.ticketCount,
    );

    // Initialize viewModel and preload images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initialize();
      precacheImage(const AssetImage('assets/images/visa.png'), context);
      precacheImage(const AssetImage('assets/images/success.svg'), context);
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void _handlePurchase(int available) async {
    final result = await viewModel.purchaseTickets(available);

    if (!mounted) return;

    if (result == null) return; // Purchase conditions not met

    if (result.startsWith('REF-')) {
      // Success - show success modal
      _showSuccessModal(result);
    } else {
      // Error - show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  void _showSuccessModal(String bookingReference) {
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
  }

  Widget _buildCardInfo() {
    return Consumer<PurchaseEventTicketViewModel>(
      builder: (context, vm, child) {
        if (!vm.hasCard || vm.userCards.isEmpty || vm.selectedCard == null) {
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<Map<String, dynamic>>(
              value: vm.selectedCard,
              isExpanded: true,
              underline: const SizedBox(),
              onChanged: vm.selectCard,
              items: vm.userCards.map((card) {
                final masked = vm.getMaskedCardNumber(card);
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
            if (vm.showCardDetails && vm.selectedCard != null)
              PaymentCardWidget(
                cardNumber: vm.selectedCard!['number'] ?? '',
                cardHolder: vm.selectedCard!['cardholder'] ?? '',
                expiryDate: vm.selectedCard!['expiry'] ?? '',
              ),
          ],
        );
      },
    );
  }

  Widget _buildQuantityCard(int available, int maxSelectable) {
    final theme = Theme.of(context);

    return Consumer<PurchaseEventTicketViewModel>(
      builder: (context, vm, child) {
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price per ticket', style: theme.textTheme.bodyMedium),
                    Text('₪${vm.event.price.toStringAsFixed(2)}', style: theme.textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantity', style: theme.textTheme.bodyMedium),
                    DropdownButton<int>(
                      value: vm.quantity,
                      onChanged: vm.isEventExpired || vm.limitExceeded
                          ? null
                          : (val) => val != null ? vm.updateQuantity(val) : null,
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
                      '${vm.remainingUserLimit}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: vm.limitExceeded ? Colors.red : null,
                        fontWeight: vm.limitExceeded ? FontWeight.bold : null,
                      ),
                    ),
                  ],
                ),
                if (vm.limitExceeded) ...[
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
        );
      },
    );
  }

  Widget _buildTotalCard() {
    final theme = Theme.of(context);

    return Consumer<PurchaseEventTicketViewModel>(
      builder: (context, vm, child) {
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TOTAL', style: theme.textTheme.titleMedium),
                Text(
                  '₪${vm.totalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPurchaseButton(int available) {
    final theme = Theme.of(context);

    return Consumer<PurchaseEventTicketViewModel>(
      builder: (context, vm, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: vm.canPurchase ? () => _handlePurchase(available) : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: vm.canPurchase ? AppColors.primary : Colors.grey,
            ),
            child: vm.isProcessing
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
              vm.buttonText,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('event')
              .doc(widget.event.eventId)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final ticketsSold = (data['ticketsSold'] as int?) ?? 0;
            final limit = (data['limite'] as int?) ?? 0;
            final available = (limit - ticketsSold).clamp(0, limit);

            return Consumer<PurchaseEventTicketViewModel>(
              builder: (context, vm, child) {
                final maxSelectable = vm.calculateMaxSelectable(available);

                // Ensure quantity doesn't exceed max selectable
                if (vm.quantity > maxSelectable && maxSelectable > 0) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    vm.updateQuantity(maxSelectable);
                  });
                }

                return SingleChildScrollView(
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
                      _buildQuantityCard(available, maxSelectable),
                      const SizedBox(height: 20),
                      _buildTotalCard(),
                      const SizedBox(height: 20),
                      _buildPurchaseButton(available),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}