import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../viewmodels/event_details_viewmodel.dart';
import '../models/event_details_model.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;

class EventDetailsPage extends StatefulWidget {
  final dynamic event;
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
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = EventDetailsViewModel(
      model: EventDetailsModel(
        eventId: widget.eventId,
        event: widget.event,
      ),
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
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        title: Text(_viewModel.model.name),
        backgroundColor: Colors.deepOrange,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.white),
            onPressed: _shareEvent,
          ),
        ],
      ),
      body: _isLoading || _viewModel.isBooking
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEventHeader(),
                  const SizedBox(height: 16),
                  _buildTicketCounterCard(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_viewModel.isEventExpired) _buildExpiredWarning(),
                        if (_viewModel.model.details?.isNotEmpty ?? false)
                          _buildDetailsSection(),
                        if (_viewModel.model.highlights.isNotEmpty)
                          _buildHighlightsSection(),
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

  Widget _buildEventHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _viewModel.model.images.isNotEmpty
            ? Column(
                children: [
                  carousel_slider.CarouselSlider(
                    items: _viewModel.model.images.map((imageUrl) {
                      return CachedNetworkImage(
                        imageUrl: imageUrl,
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
                          child: const Icon(Icons.event, size: 60, color: Colors.grey),
                        ),
                      );
                    }).toList(),
                    options: carousel_slider.CarouselOptions(
                      height: 220,
                      viewportFraction: 1.0,
                      autoPlay: _viewModel.model.images.length > 1,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                    ),
                  ),
                  if (_viewModel.model.images.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _viewModel.model.images.asMap().entries.map((entry) {
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
                child: const Icon(Icons.event, size: 60, color: Colors.grey),
              ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _viewModel.model.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on, _viewModel.model.location),
              _buildInfoRow(Icons.calendar_today, _viewModel.formatDate()),
              _buildInfoRow(Icons.access_time, _viewModel.model.formattedTime),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _viewModel.model.formattedPrice,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _viewModel.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _viewModel.isLiked ? Colors.red : Colors.grey,
                      size: 28,
                    ),
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      try {
                        await _viewModel.toggleLike();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update favorite: ${e.toString()}')),
                        );
                      }
                      setState(() => _isLoading = false);
                    },
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
          Flexible(child: Text(text, style: const TextStyle(color: Colors.grey))),
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
            _viewModel.model.details!,
            style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Highlights', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _viewModel.model.highlights.map((highlight) {
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
                  highlight,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          ),
        ],
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
          Icon(Icons.warning_amber_rounded, color: Colors.red),
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

  Widget _buildTicketCounterCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Number of Tickets',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Text(
            'Total Tickets: ${_viewModel.ticketLimit}',
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            'Available: ${_viewModel.ticketsRemaining}',
            style: TextStyle(
              fontSize: 16,
              color: _viewModel.ticketsRemaining > 0 ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle, size: 32),
                onPressed: _viewModel.ticketCount > 1
                    ? () => setState(() => _viewModel.decreaseTicketCount())
                    : null,
                color: _viewModel.ticketCount > 1 ? Colors.deepOrange : Colors.grey[400],
              ),
              const SizedBox(width: 20),
              Text(
                '${_viewModel.ticketCount}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.add_circle, size: 32),
                onPressed: _viewModel.canAddMoreTickets
                    ? () => setState(() => _viewModel.increaseTicketCount())
                    : null,
                color: _viewModel.canAddMoreTickets ? Colors.deepOrange : Colors.grey[400],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Total: ${_viewModel.formattedTotalPrice}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton(BuildContext context) {
    final isDisabled = _viewModel.isEventExpired || 
                     _viewModel.isBooking || 
                     _viewModel.ticketsRemaining <= 0;
    
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey : Colors.deepOrange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: isDisabled ? null : () async {
          setState(() => _viewModel.isBooking = true);
          try {
            await _viewModel.bookEvent();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking successful!')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking failed: ${e.toString()}')),
            );
          }
          setState(() => _viewModel.isBooking = false);
        },
        child: _viewModel.isBooking
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Book Now',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}