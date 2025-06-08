import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/event_model.dart';
import 'package:staypal/screens/admin/viewmodels/edit_event_modelview.dart';

class EditEventView extends StatelessWidget {
  final EventModel event;
  const EditEventView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditEventViewModel()..initialize(event),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Edit Event',
            style: TextStyle(
              color: Colors.black,
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Consumer<EditEventViewModel>(
          builder: (_, viewModel, __) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: viewModel.formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  children: [
                    const Text(
                      'Edit Event Details',
                      style: TextStyle(
                        fontSize: AppFontSizes.subtitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    ...viewModel.buildFormFields(context),
                    const SizedBox(height: AppSpacing.large),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              padding: const EdgeInsets.all(
                                AppPadding.containerPadding,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppBorderRadius.card,
                                ),
                              ),
                            ),
                            onPressed: () => viewModel.updateEvent(context),
                            child: const Text(
                              'Update Event',
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.betweenButtons),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppPadding.buttonVertical,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppBorderRadius.card,
                                ),
                              ),
                            ),
                            onPressed: () => viewModel.deleteEvent(context),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
