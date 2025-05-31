import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

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
      await Future.delayed(const Duration(seconds: 2));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_name),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.white),
            onPressed: _shareHotel,
          ),
        ],
      ),
      body: _isLoading || _isBooking
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHotelHeader(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Description'),
                        _buildSectionContent(_description),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Details'),
                        _buildSectionContent(_details),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Facilities'),
                        const SizedBox(height: 8),
                        _buildFacilitiesGrid(_facilities),
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

  Widget _buildHotelHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _images.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: _images[0].toString(),
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 250,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 250,
                  color: Colors.grey[200],
                  child: const Icon(Icons.hotel, size: 60, color: Colors.grey),
                ),
              )
            : Container(
                height: 250,
                color: Colors.grey[200],
                child: const Icon(Icons.hotel, size: 60, color: Colors.grey),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.deepOrange),
                  const SizedBox(width: 4),
                  Text(
                    _location,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _price,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: _toggleLike,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFacilitiesGrid(List<dynamic> facilities) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 3,
      ),
      itemCount: facilities.length,
      itemBuilder: (context, index) {
        final facility = facilities[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
            ],
          ),
          child: Text(
            facility.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
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
