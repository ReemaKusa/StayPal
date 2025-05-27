import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'event_details_viewmodel.dart';
import 'event_details_model.dart';


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
      appBar: AppBar(
        title: Text(_viewModel.model.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
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
                  SnackBar(content: Text('Failed to update favorite: ${e.toString()}')),
                );
              }
              setState(() => _isLoading = false);
            },
          ),
        ],
      ),
      body: _isLoading || _viewModel.isBooking
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
                        if (_viewModel.isEventExpired) _buildExpiredWarning(),
                        Text(
                          _viewModel.model.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.location_on, _viewModel.model.location),
                        _buildInfoRow(Icons.calendar_today, _viewModel.formatDate()),
                        _buildInfoRow(Icons.access_time, _viewModel.model.formattedTime),
                        const SizedBox(height: 16),
                        _buildTicketSelector(),
                        const SizedBox(height: 16),
                        _buildSection('Description', _viewModel.model.description),
                        _buildSection('Details', _viewModel.model.details),
                        if (_viewModel.model.highlights.isNotEmpty) _buildHighlights(),
                        const SizedBox(height: 16),
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
    final images = _viewModel.model.images;
    return SizedBox(
      height: 250,
      child: images.isEmpty
          ? Container(
              color: Colors.grey[200],
              child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
            )
          : PageView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: images[index],
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

  Widget _buildExpiredWarning() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          Icon(Icons.warning, color: Colors.red),
          SizedBox(width: 8),
          Text('This event has expired'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.deepOrange),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildTicketSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Number of Tickets',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _viewModel.decreaseTicketCount,
                  iconSize: 30,
                ),
                const SizedBox(width: 16),
                Text(
                  '${_viewModel.ticketCount}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _viewModel.increaseTicketCount,
                  iconSize: 30,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Total: ${_viewModel.formattedTotalPrice}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Highlights',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._viewModel.model.highlights.map((highlight) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(highlight, style: const TextStyle(fontSize: 16))),
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
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _viewModel.isEventExpired
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  try {
                    await _viewModel.bookEvent();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Booking successful!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  setState(() => _isLoading = false);
                },
          child: const Text(
            'Book Now',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}