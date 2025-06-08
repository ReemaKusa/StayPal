import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';
import 'upcoming_event_card.dart';

class UpcomingEventsSection extends StatelessWidget {
  final bool isWeb;

  const UpcomingEventsSection({super.key, this.isWeb = false});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200 ? 3 : width > 800 ? 2 : 1;

    if (isWeb) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Upcoming Events",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: crossAxisCount == 1 ? 4.0 : 3.0,
            ),
            itemCount: viewModel.upcomingEvents.length,
            itemBuilder: (context, index) {
              final event = viewModel.upcomingEvents[index];
              return EventCard(
                event: event, 
                isWeb: true,
              );
            },
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming Events",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Column(
          children: viewModel.upcomingEvents.map((event) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: EventCard(event: event),
            );
          }).toList(),
        ),
      ],
    );
  }
}