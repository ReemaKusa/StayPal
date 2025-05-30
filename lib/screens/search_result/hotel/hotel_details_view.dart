import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HotelDetailsPage extends StatefulWidget {
  final dynamic hotel;
  final String hotelId;
  final bool isInitiallyLiked;

  const HotelDetailsPage({
    Key? key,
    required this.hotel,
    required this.hotelId,
    this.isInitiallyLiked = false,
  }) : super(key: key);

  @override
  _HotelDetailsPageState createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  late Map<String, dynamic> _hotel;
  late bool _isLiked;
  bool _isLoading = false;
  bool _isBooking = false;
  int _ticketCount = 1;

  @override
  void initState() {
    super.initState();
    _hotel = widget.hotel;
    _isLiked = widget.isInitiallyLiked;
  }

  String get _name => _hotel['name'] ?? 'No Name';
  String get _location => _hotel['location'] ?? 'Unknown Location';
  String get _price => '${_hotel['price'] ?? 'N/A'} ₪ per night';
  String get _description => _hotel['description'] ?? 'No description available';
  String get _details => _hotel['details'] ?? 'No details available';
  double get _rating => (_hotel['rating'] ?? 0).toDouble();
  List<dynamic> get _images => _hotel['images'] ?? [];
  List<dynamic> get _facilities => _hotel['facilities'] ?? [];

  String get _shareMessage {
    return 'Check out this hotel: $_name located at $_location. Price: $_price';
  }

  Future<void> _toggleLike() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('hotel')
          .doc(widget.hotelId)
          .update({'isFavorite': !_isLiked});
      setState(() => _isLiked = !_isLiked);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite: ${e.toString()}')),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _shareHotel() async {
    try {
      await Share.share(_shareMessage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share: ${e.toString()}')),
      );
    }
  }

  Future<void> _bookHotel() async {
    setState(() => _isBooking = true);
    try {
      // Implement your booking logic here
      await Future.delayed(const Duration(seconds: 2)); // Simulate booking
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() => _isBooking = false);
  }

  void _increaseTicketCount() {
    setState(() => _ticketCount++);
  }

  void _decreaseTicketCount() {
    if (_ticketCount > 1) {
      setState(() => _ticketCount--);
    }
  }

  String get _formattedTotalPrice {
    final price = (_hotel['price'] ?? 0).toDouble();
    return '${(price * _ticketCount).toStringAsFixed(2)} ₪';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareHotel,
          ),
          IconButton(
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.red : Colors.white,
            ),
            onPressed: _toggleLike,
          ),
        ],
      ),
      body: _isLoading || _isBooking
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildImageSlider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(Icons.location_on, _location),
                        const SizedBox(height: 20),
                        Text(
                          _price,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Description'),
                        _buildSectionContent(_description),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Details'),
                        _buildSectionContent(_details),
                        const SizedBox(height: 20),
                        _buildFacilities(),
                        const SizedBox(height: 30),
                        _buildBookButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildImageSlider() {
    return SizedBox(
      height: 250,
      child: _images.isEmpty
          ? Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.hotel, size: 60, color: Colors.grey),
              ),
            )
          : PageView.builder(
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: _images[index].toString(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error_outline, color: Colors.red),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.deepOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 16, height: 1.6),
    );
  }

  Widget _buildFacilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Facilities'),
        const SizedBox(height: 8),
        ..._facilities.map((facility) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      facility.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildBookButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
          onPressed: () async {
            setState(() => _isBooking = true);
            try {
              await _bookHotel();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            setState(() => _isBooking = false);
          },
          child: const Text(
            'Book Now',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}