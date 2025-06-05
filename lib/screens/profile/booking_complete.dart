/*import 'package:flutter/material.dart';

class BookingCompleteScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  final String type; // "hotel" or "event"

  const BookingCompleteScreen({
    super.key,
    required this.bookingData,
    required this.type,
  });

  bool get isHotel => type == "hotel";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black38, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: Image.asset('assets/images/payment.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Booking Complete',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 30),
            Text(
              isHotel
                  ? 'Your Payment Was Successful,\nSee You At The Hotel'
                  : 'Your Payment Was Successful,\nSee You At The Event',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black45),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (isHotel) {
                    Navigator.pushNamed(context, '/hotelDetails', arguments: bookingData);
                  } else {
                    Navigator.pushNamed(context, '/eventTicket', arguments: bookingData);
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 7,
                  backgroundColor: Colors.orange[700],
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  isHotel ? 'View Hotel' : 'View Ticket',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, isHotel ? '/hotels' : '/events');
                },
                style: ElevatedButton.styleFrom(
                  elevation: 7.0,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  isHotel ? 'Discover More Hotels' : 'Discover More Events',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black38),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/