import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/event_model.dart';
import 'package:staypal/screens/admin/viewmodels/list_events_viewmodel.dart';
import 'edit_event_view.dart';

class ListEventsView extends StatelessWidget {
  const ListEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListEventsViewModel()..fetchEvents(),
      child: Consumer<ListEventsViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.error != null) {
            return Center(child: Text('Error: ${viewModel.error}'));
          } else if (viewModel.events.isEmpty) {
            return const Center(child: Text('No events found.'));
          }

          final events = viewModel.events;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 720;
              return Padding(
                padding: const EdgeInsets.all(AppPadding.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available Events',
                      style: TextStyle(
                        fontSize: AppFontSizes.title,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Expanded(
                      child: GridView.builder(
                        itemCount: events.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWide ? 2 : 1,
                          crossAxisSpacing: AppSpacing.small,
                          mainAxisSpacing: AppSpacing.small,
                          childAspectRatio: 5 / 4,
                        ),
                        itemBuilder: (context, index) {
                          final event = events[index];
                          final imageUrl =
                              event.images.isNotEmpty
                                  ? event.images.first
                                  : 'https://via.placeholder.com/300x200.png?text=No+Image';

                          return Stack(
                            children: [
                              Card(
                                color: AppColors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppBorderRadius.card,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(
                                          AppBorderRadius.card,
                                        ),
                                      ),
                                      child: Image.network(
                                        imageUrl,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(
                                              height: AppSpacing.small,
                                            ),
                                            Text(
                                              event.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: AppFontSizes.subtitle,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.xSmall,
                                            ),
                                            Text(
                                              event.location,
                                              style: const TextStyle(
                                                fontSize: AppFontSizes.body,
                                                color: AppColors.grey,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.xSmall,
                                            ),
                                            Text(
                                              event.formattedPrice,
                                              style: const TextStyle(
                                                fontSize:
                                                    AppFontSizes.bottonfont,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.small,
                                            ),
                                            Text(
                                              event.description,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: AppFontSizes.body,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: AppSpacing.small,
                                right: AppSpacing.small,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => EditEventView(event: event),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
