import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:staypal/screens/booking/views/purchase_event_ticket_view.dart';
import '../viewmodels/event_details_viewmodel.dart';
import '../models/event_details_model.dart';
import '../../../reviewSection/views/review.dart';
import '../../../../widgets/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = EventDetailsViewModel(
      model: EventDetailsModel(eventId: widget.eventId, event: widget.event),
      isInitiallyLiked: widget.isInitiallyLiked,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  void _openImageGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: PhotoViewGallery.builder(
            itemCount: _viewModel.model.images.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(_viewModel.model.images[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: PageController(initialPage: initialIndex),
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventDetailsViewModel>.value(
      value: _viewModel,
      child: Consumer<EventDetailsViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(viewModel.model.name),
              backgroundColor: Colors.deepOrange,
              actions: [
                IconButton(
                  icon: const Icon(Icons.ios_share, color: Color.fromARGB(255, 12, 12, 12)),
                  onPressed: _shareEvent,
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
          _buildImageSlider(viewModel),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewModel.isEventExpired) _buildExpiredWarning(),
                Text(
                  viewModel.model.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.location_on, viewModel.model.location),
                _buildDetailRow(Icons.calendar_today, viewModel.formatDate()),
                _buildTimeRow(viewModel),
                _buildPriceRow(viewModel),
                const SizedBox(height: 8),
                _buildRemainingTickets(viewModel),
                const SizedBox(height: 20),
                if (viewModel.model.highlights.isNotEmpty) _buildHighlights(viewModel),
                const SizedBox(height: 20),
                if (viewModel.model.details?.isNotEmpty ?? false) ...[
                  _buildSectionTitle('Details'),
                  _buildSectionContent(viewModel.model.details!),
                  const SizedBox(height: 20),
                ],
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
                _buildBookButton(context, viewModel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingTickets(EventDetailsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.deepOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.deepOrange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.confirmation_number, color: Colors.deepOrange),
          const SizedBox(width: 12),
          Text(
            'Tickets Available: ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            '${viewModel.remainingTickets}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: viewModel.remainingTickets > 0 ? Colors.deepOrange : Colors.red,
            ),
          ),
          const Spacer(),
          if (viewModel.remainingTickets <= 5 && viewModel.remainingTickets > 0)
            Text(
              'Hurry! Only few left',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.deepOrange,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSlider(EventDetailsViewModel viewModel) {
    final images = viewModel.model.images;
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => _openImageGallery(context, _currentImageIndex),
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
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
          ),
          if (images.length > 1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? Colors.deepOrange
                          : Colors.white.withOpacity(0.5),
                    ),
                  );
                }),
              ),
            ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentImageIndex + 1}/${images.length}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
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
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(EventDetailsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.access_time, size: 24, color: Colors.deepOrange),
          const SizedBox(width: 12),
          Text(
            viewModel.model.formattedTime,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(EventDetailsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 5,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '₪',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${viewModel.model.price.toStringAsFixed(2)} ₪',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
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
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
    );
  }

  Widget _buildHighlights(EventDetailsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Highlights'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: viewModel.model.highlights.map((highlight) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              highlight,
              style: const TextStyle(fontSize: 14),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildBookButton(BuildContext context, EventDetailsViewModel viewModel) {
    return SizedBox(
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
        onPressed: viewModel.remainingTickets > 0 && !viewModel.isEventExpired
            ? () async {
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

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PurchaseEventTicketView(
                event: viewModel.model.toEventModel(),
                ticketCount: viewModel.ticketCount,
              ),
            ),
          );
          await viewModel.reloadEventData();
        }
            : null,
        child: Text(
          viewModel.isEventExpired ? 'Event Ended' : 'Buy Ticket',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}