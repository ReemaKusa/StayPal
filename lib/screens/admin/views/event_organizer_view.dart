import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/screens/admin/viewmodels/EventOrganizerviewmodel.dart';
import 'package:staypal/screens/admin/views/edit_event_view.dart';
import 'package:staypal/screens/admin/views/add_event_view.dart';

class EventOrganizerView extends StatelessWidget {
  const EventOrganizerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventOrganizerViewModel()..fetchMyEvents(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('My Events')),
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEventView()),
              ).then((_) {
                context.read<EventOrganizerViewModel>().fetchMyEvents(); // ✅ Safe here
              });
            },
            child: const Icon(Icons.add),
          ),
          body: Consumer<EventOrganizerViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.myEvents.isEmpty) {
                return const Center(child: Text('No events found.'));
              }

              return ListView.builder(
                itemCount: viewModel.myEvents.length,
                itemBuilder: (context, index) {
                  final event = viewModel.myEvents[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(event.name),
                      subtitle: Text(event.date?.toLocal().toString().split(" ")[0] ?? 'No date'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.deepPurple),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditEventView(event: event),
                                ),
                              ).then((_) {
                                context.read<EventOrganizerViewModel>().fetchMyEvents();
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Delete Event'),
                                  content: const Text('Are you sure you want to delete this event?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await context.read<EventOrganizerViewModel>().deleteEvent(event.eventId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('✅ Event deleted')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}