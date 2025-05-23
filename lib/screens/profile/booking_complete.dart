import 'package:flutter/material.dart';

class BookingCompleteScreen extends StatelessWidget {
  late final bool isHotel;
  BookingCompleteScreen({required this.isHotel});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black38, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16),

        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Container(
                child: Image.asset('assets/images/payment.png'),
                height: 300,
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              width: double.infinity,
              color: Colors.white,
              child: Text(
                'Booking Complete',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30),

            Container(
              alignment: AlignmentDirectional.center,
              width: double.infinity,
              color: Colors.white,
              child: Text(
                isHotel == "true"
                    ? 'Your Payment Was Successful , \nSee You At The Hotel'
                    : 'Your Payment Was Successful , \nSee You At The Event',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,

                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //navigator
                },
                style: ElevatedButton.styleFrom(
                  elevation: 7,
                  backgroundColor: Colors.orange[700],
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Text(
                  isHotel ? 'View Hotel' : 'View Ticket',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //navigator
                },
                style: ElevatedButton.styleFrom(
                  elevation: 7.0,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isHotel ? 'Discover More Hotels' : 'Discover More Events',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
