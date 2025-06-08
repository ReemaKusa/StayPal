import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/screens/profile/views/add_visa.dart';
import 'package:staypal/widgets/visa_card.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  late final String? userId;
  late final CollectionReference cardsRef;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    cardsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards');
  }

  Widget _buildCardWidget(Map<String, dynamic> data) {
    return PaymentCardWidget(
      cardNumber: data['number'] ?? '',
      cardHolder: data['cardholder'] ?? '',
      expiryDate: data['expiry'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,

        title: const Text(
          'Payment details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: cardsRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final cards = snapshot.data?.docs ?? [];

              if (cards.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Payment details',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Securely add or remove payment methods to\nmake it easier when you book.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: AppFontSizes.body,
                          ),
                        ),
                        SizedBox(height: 100),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                              vertical: AppPadding.buttonVertical,
                                            ),
                                side: BorderSide(
                                  color: AppColors.greyTransparent,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AddCardView(),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                              child: const Text(
                                'Add Card',
                                style: TextStyle(
                                  fontSize: AppFontSizes.bottonfont,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                                      letterSpacing: 1,
                              
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final data = cards.first.data() as Map<String, dynamic>;
              final docRef = cards.first.reference;

              return Stack(
  children: [
    ListView(
      
  padding: EdgeInsets.all(10),
      children: [
        _buildCardWidget(data),
      ],
    ),

    Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  minimumSize: const Size.fromHeight(50),
                  side: const BorderSide(color: AppColors.greyTransparent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await docRef.delete();
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: AppFontSizes.bottonfont,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  minimumSize: const Size.fromHeight(50),
                  side: const BorderSide(color: AppColors.greyTransparent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddCardView()),
                  ).then((_) => setState(() {}));
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: AppFontSizes.bottonfont,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
);

            },
          ),
        ],
      ),
    );
  }
}
