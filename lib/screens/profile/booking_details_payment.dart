import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailBooking extends StatelessWidget {
  DateTime now = DateTime.now();

  String formattedDateVerbose = DateFormat(
    'd MMMM yyyy',
  ).format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Booking Details',

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/hotel.png',
                height: 250,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Hotel/Event photo',

              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(' $formattedDateVerbose', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),

            Text(
              'Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildOrderSummary('price', '\$35.00'),
            _buildOrderSummary('Soccer', '\$35.00'),
            _buildOrderSummary('Fees', '\$2.11'),
            Divider(thickness: 1),
            _buildOrderSummary('Total', '\$37.11', isTotal: true),
            SizedBox(height: 20),

            Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Paypal', style: TextStyle(fontSize: 16)),
                Spacer(),

                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Change',
                    style: TextStyle(color: Colors.orange[700]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$37.11',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 50,
                    ),
                  ),
                  child: Text(
                    'Place Order',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    String title,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
