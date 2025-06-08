import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:staypal/screens/booking/views/purchase_event_ticket_view.dart';
import 'package:intl/intl.dart';
import '../viewmodels/event_details_viewmodel.dart';
import '../models/event_details_model.dart';
import '../../../reviewSection/views/review.dart';
import '../../../../widgets/custom_nav_bar.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider<EventDetailsViewModel>.value(
      value: _viewModel,
      child: Consumer<EventDetailsViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(viewModel.model.name),
              backgroundColor: Colors.deepOrange,
              actions: [
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: _shareEvent,
                ),
                IconButton(
                  icon: Icon(
                    viewModel.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: viewModel.isLiked ? Colors.red : Colors.white,
                  ),
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    try {
                      await viewModel.toggleLike();
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
            body: _isLoading || viewModel.isBooking
                ? const Center(child: CircularProgressIndicator())
                : _buildBody(viewModel),
            bottomNavigationBar: CustomNavBar(
              currentIndex: 1,
              searchKey: GlobalKey(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(EventDetailsViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 250, child: _buildImageSlider()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewModel.isEventExpired) _buildExpiredWarning(),
                Text(
                  viewModel.model.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.location_on, viewModel.model.location),
                _buildDetailRow(Icons.calendar_today, viewModel.formatDate()),
                _buildDetailRow(Icons.access_time, viewModel.model.formattedTime),
                _buildRemainingTicketsCard(viewModel),
                const SizedBox(height: 20),
                _buildPriceSection(),
                const SizedBox(height: 20),
                _buildSectionTitle('Description'),
                _buildSectionContent(viewModel.model.description),
                const SizedBox(height: 20),
                if (viewModel.model.details?.isNotEmpty ?? false) ...[
                  _buildSectionTitle('Details'),
                  _buildSectionContent(viewModel.model.details!),
                  const SizedBox(height: 20),
                ],
                if (viewModel.model.highlights.isNotEmpty) _buildHighlights(),
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
                        'Event Reviews',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        child: FeedbackScreen(
                          serviceId: widget.eventId,
                          serviceName: viewModel.model.name,
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
    );
  }

  Widget _buildRemainingTicketsCard(EventDetailsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.confirmation_num, color: Colors.deepOrange, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tickets left: ${viewModel.remainingTickets}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
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
        child: const Center(child: Icon(Icons.event, size: 60, color: Colors.grey)),
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
            child: Text('This event has already ended', style: TextStyle(color: Colors.red)),
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: SizedBox(
        height: 150, // original size
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
            Flexible(
              child: Text(
                '${_viewModel.ticketCount}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
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
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                Expanded(child: Text(highlight, style: const TextStyle(fontSize: 16))),
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
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PurchaseEventTicketView(
                  event: _viewModel.model.toEventModel(),
                  ticketCount: _viewModel.ticketCount,
                ),
              ),
            );
            await _viewModel.reloadEventData(); // update tickets left
          },
          child: const Text(
            'Buy Ticket',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}