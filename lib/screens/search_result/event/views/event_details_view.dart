import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../viewmodels/event_details_viewmodel.dart';
import '../models/event_details_model.dart';

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
      backgroundColor: const Color(0xFFF9F9F9),
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
                  _buildEventCard(),
                  const SizedBox(height: 16),
                  _buildTicketCounterCard(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_viewModel.isEventExpired) _buildExpiredWarning(),
                        _buildSectionTitle('Description'),
                        _buildSectionContent(_viewModel.model.description),
                        const SizedBox(height: 24),
                        if (_viewModel.model.details?.isNotEmpty ?? false) ...[
                          _buildSectionTitle('Details'),
                          _buildSectionContent(_viewModel.model.details!),
                          const SizedBox(height: 24),
                        ],
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

  Widget _buildEventCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: _viewModel.model.images.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: _viewModel.model.images[0],
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
                  )
                : Container(
                    height: 220,
                    color: Colors.grey[200],
                    child: const Icon(Icons.event, size: 60, color: Colors.grey),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _viewModel.model.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Colors.deepOrange),
                    const SizedBox(width: 6),
                    Text(_viewModel.model.location, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: Colors.deepOrange),
                    const SizedBox(width: 6),
                    Text(_viewModel.formatDate(), style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Colors.deepOrange),
                    const SizedBox(width: 6),
                    Text(_viewModel.model.formattedTime, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
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
                            SnackBar(
                                content: Text('Failed to update favorite: ${e.toString()}')),
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
                onPressed: () => setState(() => _viewModel.increaseTicketCount()),
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
    return Text(
      content,
      style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
    );
  }

  Widget _buildHighlightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Highlights'),
        const SizedBox(height: 8),
        _buildHighlightsGrid(_viewModel.model.highlights),
      ],
    );
  }

  Widget _buildHighlightsGrid(List<String> highlights) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 4,
      ),
      itemCount: highlights.length,
      itemBuilder: (context, index) {
        final highlight = highlights[index];
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
            highlight,
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  Widget _buildBookButton(BuildContext context) {
    final isDisabled = _viewModel.isEventExpired || _viewModel.isBooking;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey : Colors.deepOrange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: isDisabled
            ? null
            : () async {
                setState(() {
                  _viewModel.isBooking = true;
                });
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
                setState(() {
                  _viewModel.isBooking = false;
                });
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