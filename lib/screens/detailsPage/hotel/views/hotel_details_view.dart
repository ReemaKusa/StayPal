import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../widgets/custom_nav_bar.dart';
import '../../../notification/notification_viewmodel.dart';
import '../../../reviewSection/views/review.dart';
import 'package:staypal/screens/booking/views/book_hotel_view.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
  final NotificationViewModel _notificationViewModel = NotificationViewModel();

  @override
  void initState() {
    super.initState();
    _hotel = widget.hotel;
    _isLiked = widget.isInitiallyLiked;
  }

  String get _name => _hotel['name'] ?? 'No Name';
  String get _location => _hotel['location'] ?? 'Unknown Location';
  String get _price => '${_hotel['price'] ?? 'N/A'} ₪ per night';
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
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userFavoritesRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(widget.hotelId);

        if (_isLiked) {
          await userFavoritesRef.delete();
          await _notificationViewModel.removeLikeNotification(user.uid, widget.hotelId);
        } else {
          await userFavoritesRef.set({
            'hotelId': widget.hotelId,
            'hotelName': _name,
            'timestamp': FieldValue.serverTimestamp(),
          });
          
          await _notificationViewModel.addNotification(
            userId: user.uid,
            title: 'New Like',
            message: 'You liked $_name hotel',
            type: 'like',
            actionRoute: '/hotel/${widget.hotelId}',
            targetName: _name,
            targetId: widget.hotelId,
            imageUrls: _images.isNotEmpty ? List<String>.from(_images) : [],
          );
        }
        setState(() => _isLiked = !_isLiked);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to save favorites')),
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
      await Share.share(_shareMessage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.black),
            onPressed: _shareHotel,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 250, child: _buildPhotoViewGallery()),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _price,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
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

                        const SizedBox(height: 20),


                        _buildSectionTitle('Details'),
                        _buildSectionContent(_details),
                        const SizedBox(height: 20),
                        _buildFacilities(),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hotel Reviews',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.8,
                                ),
                                child: FeedbackScreen(
                                  serviceId: widget.hotelId,
                                  serviceName: _name,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildBookButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 1,
        searchKey: GlobalKey(),
      ),
    );
  }

  Widget _buildPhotoViewGallery() {
    if (_images.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.hotel, size: 60, color: Colors.grey),
        ),
      );
    }

    return PhotoViewGallery.builder(
      itemCount: _images.length,
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(_images[index]),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2.5,
          heroAttributes: PhotoViewHeroAttributes(tag: _images[index]),
        );
      },
      scrollPhysics: const BouncingScrollPhysics(),
      backgroundDecoration: const BoxDecoration(color: Colors.white),
      loadingBuilder: (context, progress) => const Center(
        child: CircularProgressIndicator(),
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
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(content, style: const TextStyle(fontSize: 16, height: 1.6));
  }

  Widget _buildFacilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Facilities'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _facilities.map<Widget>((facility) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                facility.toString(),
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
        ),
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
          onPressed: () {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) => Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.login,
                          size: 32, color: Colors.deepOrange),
                      const SizedBox(height: 16),
                      const Text(
                        'You need to log in to continue',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                side: const BorderSide(color: Colors.grey),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/login');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                              ),
                              child: const Text('Log In',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookHotelView(
                  hotelId: widget.hotelId,
                  hotelName: _name,
                  pricePerNight: (_hotel['price'] ?? 0).toDouble(),
                ),
              ),
            );
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