import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/event_model.dart';
import 'package:staypal/screens/admin/viewmodels/edit_event_viewmodel.dart';

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

          iconTheme: const IconThemeData(color: AppColors.black),
          title: Text(
            'Edit Event',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),

        body: Consumer<EditEventViewModel>(
          builder: (_, viewModel, __) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(

              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.formHorizontal,
                vertical: AppPadding.formVertical,
              ),
              child: Form(
                key: viewModel.formKey,
                child: Center(
                  child: Container(
                                width: AppDimensions.formWidth,
                  
                    padding:EdgeInsets.all( AppPadding.containerPadding),
                    decoration: BoxDecoration(
                                        color: AppColors.white,
                  
                     boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: AppShadows.cardBlur,
                  ),
                                ],
                                borderRadius: BorderRadius.circular(AppBorderRadius.card),
                                
                    ),
                    child: ListView(
                    
                      children: [
                        const Text(
                          'Edit Event Details',
                          style: TextStyle(
                            fontSize: AppFontSizes.title,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         SizedBox(height: AppSpacing.large),
                        ...viewModel.buildFormFields(context),
                        const SizedBox(height: AppSpacing.large),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  padding:  EdgeInsets.symmetric(
                                    vertical: AppPadding.buttonVertical,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    
                                    side: BorderSide(color: AppColors.primary,width: 0.5),
                                    borderRadius: BorderRadius.circular(
                                      
                                      AppBorderRadius.card,
                                      
                                    ),
                                  ),
                                ),
                                onPressed: () => viewModel.updateEvent(context),
                                child: Text(
                                  'Update Event',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primary),
                                ),
                              ),
                            ),
                             SizedBox(width: AppSpacing.small),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                  padding:  EdgeInsets.symmetric(
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
