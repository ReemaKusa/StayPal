import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../viewmodels/event_details_viewmodel.dart';
import '../models/event_details_model.dart';
import '../../../reviewSection/views/review.dart';
import '../../../homePage/widgets/custom_nav_bar.dart';

class EventDetailsPage extends StatefulWidget {
  final Map<String, dynamic> event;
  final String eventId;
  final bool isInitiallyLiked;

  const EventDetailsPage({
    Key? key,
    required this.event,
    required this.eventId,
    this.isInitiallyLiked = false,
  }) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late EventDetailsViewModel _viewModel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _viewModel = EventDetailsViewModel(
      model: EventDetailsModel(eventId: widget.eventId, event: widget.event),
      isInitiallyLiked: widget.isInitiallyLiked,
    );
  }

  Future<void> _shareEvent() async {
    try {
      await Share.share(_viewModel.getShareContent());
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
        title: Text(_viewModel.model.name),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareEvent,
          ),
          IconButton(
            icon: Icon(
              _viewModel.isLiked ? Icons.favorite : Icons.favorite_border,
              color: _viewModel.isLiked ? Colors.red : Colors.white,
            ),
            onPressed: () async {
              setState(() => _isLoading = true);
              try {
                await _viewModel.toggleLike();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update favorite: ${e.toString()}'),
                  ),
                );
              }
              setState(() => _isLoading = false);
            },
          ),
        ],
      ),
      body:
          _isLoading || _viewModel.isBooking
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    // Image Slider with fixed height
                    SizedBox(height: 250, child: _buildImageSlider()),

                    // Main Content Area
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event status warning
                          if (_viewModel.isEventExpired) _buildExpiredWarning(),

                          // Event title
                          Text(
                            _viewModel.model.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Event details rows
                          _buildDetailRow(
                            Icons.location_on,
                            _viewModel.model.location,
                          ),
                          _buildDetailRow(
                            Icons.calendar_today,
                            _viewModel.formatDate(),
                          ),
                          _buildDetailRow(
                            Icons.access_time,
                            _viewModel.model.formattedTime,
                          ),
                          const SizedBox(height: 20),

                          // Price section
                          _buildPriceSection(),
                          const SizedBox(height: 20),

                          // Description
                          _buildSectionTitle('Description'),
                          _buildSectionContent(_viewModel.model.description),
                          const SizedBox(height: 20),

                          // Additional details if available
                          if (_viewModel.model.details?.isNotEmpty ??
                              false) ...[
                            _buildSectionTitle('Details'),
                            _buildSectionContent(_viewModel.model.details!),
                            const SizedBox(height: 20),
                          ],

                          // Highlights if available
                          if (_viewModel.model.highlights.isNotEmpty)
                            _buildHighlights(),
                          const SizedBox(height: 30),

                          // Feedback Section - Improved layout
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
                                  'Event Reviews',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Reviews list with constrained height
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                        0.8,
                                  ),
                                  child: FeedbackScreen(
                                    serviceId: widget.eventId,
                                    serviceName: _viewModel.model.name,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Book Now button
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

  Widget _buildImageSlider() {
    final images = _viewModel.model.images;
    return SizedBox(
      height: 250,
      child:
          images.isEmpty
              ? Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.event, size: 60, color: Colors.grey),
                ),
              )
              : PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ),
                        ),
                  );
                },
              ),
    );
  }

  Widget _buildExpiredWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: const [
          Icon(Icons.warning_amber, color: Colors.red),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'This event has already ended',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
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

  Widget _buildPriceSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Price per ticket',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _viewModel.model.formattedPrice,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 16),
            _buildTicketCounter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCounter() {
    return Column(
      children: [
        const Text('Number of Tickets', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 32),
              onPressed: _viewModel.decreaseTicketCount,
              color: Colors.deepOrange,
            ),
            const SizedBox(width: 20),
            Text(
              '${_viewModel.ticketCount}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 32),
              onPressed: _viewModel.increaseTicketCount,
              color: Colors.deepOrange,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Total: ${_viewModel.formattedTotalPrice}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
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

  Widget _buildHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Highlights'),
        const SizedBox(height: 8),
        ..._viewModel.model.highlights.map(
          (highlight) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(highlight, style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
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
            backgroundColor:
                _viewModel.isEventExpired ? Colors.grey : Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
          onPressed:
              _viewModel.isEventExpired
                  ? null
                  : () async {
                    setState(() => _isLoading = true);
                    try {
                      await _viewModel.bookEvent();
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
                    setState(() => _isLoading = false);
                  },
          child: Text(
            _viewModel.isEventExpired ? 'Event Expired' : 'Book Now',
            style: const TextStyle(
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
