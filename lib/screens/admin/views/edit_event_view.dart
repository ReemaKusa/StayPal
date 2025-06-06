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
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: const Text(
            'Edit Event',
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.black),
        ),
        body: Consumer<EditEventViewModel>(
          builder: (_, viewModel, __) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.large,
                horizontal: AppSpacing.medium,
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(AppPadding.screenPadding),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppBorderRadius.card),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: AppSpacing.medium),
                    ],
                  ),
                  child: Form(
                    key: viewModel.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 140,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppPadding.buttonVertical,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppBorderRadius.card),
                                  ),
                                ),
                                onPressed: () => viewModel.updateEvent(context),
                                child: const Text(
                                  'Update Event',
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.betweenButtons),
                            SizedBox(
                              width: 140,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.red,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppPadding.buttonIconVertical,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppBorderRadius.card),
                                  ),
                                ),
                                onPressed: () => viewModel.deleteEvent(context),
                                label: const Text(
                                  'Delete',
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
