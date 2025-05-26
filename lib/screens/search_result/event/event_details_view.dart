import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'event_details_viewmodel.dart';

class EventDetailsPage extends StatefulWidget {
  final Map<String, dynamic> event;
  final String eventId;
  final bool isInitiallyLiked;

  const EventDetailsPage({
    super.key,
    required this.event,
    required this.eventId,
    this.isInitiallyLiked = false,
  });

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late final EventDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EventDetailsViewModel(
      event: widget.event,
      eventId: widget.eventId,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EventDetailsState>(
      valueListenable: _viewModel.stateNotifier,
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_viewModel.event['name'] ?? 'Event Details'),
            backgroundColor: Colors.deepOrange,
            actions: [
              IconButton(
                icon: const Icon(Icons.ios_share, color: Colors.black),
                onPressed: _viewModel.shareOptions,
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.deepOrange,
            unselectedItemColor: Colors.grey,
            currentIndex: 0,
            onTap: (index) => _viewModel.onItemTapped(context, index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (state.isEventExpired)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'This event has already passed',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    _buildDetailImage(state.images.isNotEmpty ? state.images[0] : null),
                    const SizedBox(height: 20),
                    Text(
                      _viewModel.event['name'] ?? 'Event Details',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, color: Colors.deepOrange),
                        const SizedBox(width: 4),
                        Text(_viewModel.event['location'] ?? 'Unknown Location'),
                      ], 
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.deepOrange),
                        const SizedBox(width: 4),
                        Text(_viewModel.formatDate(_viewModel.event['date'])),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time, color: Colors.deepOrange  ),
                        const SizedBox(width: 4),
                        Text(_viewModel.event['time'] ?? 'No Time Specified'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Number of Tickets',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                color: Colors.deepOrange,
                                onPressed: () {
                                  if (state.ticketCount > 1) {
                                    _viewModel.updateTicketCount(state.ticketCount - 1);
                                  }
                                },
                              ),
                              Text(
                                '${state.ticketCount}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                color: Colors.deepOrange,
                                onPressed: () {
                                  _viewModel.updateTicketCount(state.ticketCount + 1);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Total Price: ₪${state.totalPrice}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSection('Description', _viewModel.event['description'] ?? 'No description available'),
                    _buildSection('Details', _viewModel.event['details'] ?? 'No details available'),
                    if ((_viewModel.event['highlights'] as List?)?.isNotEmpty ?? false)
                      _buildHighlights(_viewModel.event['highlights'] as List),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.deepOrange),
                        const SizedBox(width: 6),
                        Text(_viewModel.event['rating']?.toString() ?? 'N/A'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: state.isEventExpired
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Booking functionality not implemented yet')),
                              );
                            },
                      child: const Text(
                        'Book Now',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailImage(dynamic imageUrl) {
    if (imageUrl == null || imageUrl.toString().isEmpty) {
      return const Icon(
        Icons.image_not_supported_outlined,
        size: 250,
        color: Colors.grey,
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 250,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange[800]),
        ),
        const SizedBox(height: 10),
        Text(content),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHighlights(List highlights) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Highlights',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange[800]),
        ),
        const SizedBox(height: 10),
        ...highlights.map((h) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.check, color: Colors.deepOrange),
                  const SizedBox(width: 6),
                  Flexible(child: Text(h.toString())),
                ],
              ),
            )),
        const SizedBox(height: 20),
      ],
    );
  }
}