import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:staypal/screens/notification/notification_viewmodel.dart';

class HotelDetailsPage extends StatefulWidget {
  final Map<String, dynamic> hotel;
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
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _hotel = widget.hotel;
    _isLiked = widget.isInitiallyLiked;
  }

  String get _name => _hotel['name'] ?? 'Unnamed Hotel';
  String get _location => _hotel['location'] ?? 'Location not specified';
  String get _details => _hotel['details'] ?? 'No details available';
  double get _price => _hotel['price'] is num ? _hotel['price'].toDouble() : 0.0;
  List<dynamic> get _images => _hotel['images'] ?? [];
  List<dynamic> get _facilities => _hotel['facilities'] ?? [];
  List<dynamic> get _services => _hotel['services'] ?? [];
  String get _rating => _hotel['rating']?.toString() ?? '0';

  String get _formattedPrice => '₪${_price.toStringAsFixed(2)}';

  String get _shareMessage {
    return '''
🏨 $_name
📍 $_location
⭐ $_rating Stars
💰 $_formattedPrice / night

${_details.isNotEmpty ? _details : ''}

Facilities:
${_facilities.map((f) => '✅ $f').join('\n')}

Services:
${_services.map((s) => '✔️ $s').join('\n')}

Check out this amazing hotel!''';
  }

  Future<void> _toggleLike() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('hotel')
          .doc(widget.hotelId)
          .update({'isFavorite': !_isLiked});
      
      setState(() => _isLiked = !_isLiked);
      
      if (_isLiked) {
        final notificationViewModel = NotificationViewModel();
        notificationViewModel.addNotification(
          title: 'New Like',
          message: 'You liked $_name',
          type: 'like',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite: ${e.toString()}')),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _shareHotel() async {
    try {
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(
        _shareMessage,
        subject: '$_name Hotel Details',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
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
      
      final notificationViewModel = NotificationViewModel();
      notificationViewModel.addNotification(
        title: 'Booking Confirmed',
        message: 'Your booking at $_name has been confirmed',
        type: 'booking',
      );
      
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
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        title: Text(_name),
        backgroundColor: Colors.deepOrange,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Color.fromARGB(255, 46, 45, 45)),
            onPressed: _shareHotel,
          ),
        ],
      ),
      body: _isLoading || _isBooking
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHotelHeader(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_details.isNotEmpty) _buildDetailsSection(),
                        if (_facilities.isNotEmpty) _buildFacilitiesSection(),
                        if (_services.isNotEmpty) _buildServicesSection(),
                        const SizedBox(height: 30),
                        _buildBookButton(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
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
            ? Column(
                children: [
                  carousel_slider.CarouselSlider(
                    items: _images.map((imageUrl) {
                      return CachedNetworkImage(
                        imageUrl: imageUrl.toString(),
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 220,
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 220,
                          color: Colors.grey[200],
                          child: const Icon(Icons.hotel, size: 60, color: Colors.grey),
                        ),
                      );
                    }).toList(),
                    options: carousel_slider.CarouselOptions(
                      height: 220,
                      viewportFraction: 1.0,
                      autoPlay: _images.length > 1,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                    ),
                  ),
                  if (_images.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _images.asMap().entries.map((entry) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == entry.key
                                ? Colors.deepOrange
                                : Colors.grey,
                          ),
                        );
                      }).toList(),
                    ),
                ],
              )
            : Container(
                height: 220,
                color: Colors.grey[200],
                child: const Icon(Icons.hotel, size: 60, color: Colors.grey),
              ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on, _location),
              _buildInfoRow(Icons.star, '${_hotel['rating'] ?? '0'} Stars'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_formattedPrice / night',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.grey,
                      size: 28,
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.deepOrange),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            _details,
            style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Facilities',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _facilities.map((facility) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
                  ],
                ),
                child: Text(
                  facility.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Services',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: _services.map((service) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, size: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        service.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _isBooking ? null : () async {
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
        child: _isBooking
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Book Now',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}