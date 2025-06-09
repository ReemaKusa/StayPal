import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/models/hotel_model.dart';
import 'package:staypal/screens/admin/viewmodels/edit_hotel_viewmodel.dart';

class EditHotelView extends StatelessWidget {
  final HotelModel hotel;
  const EditHotelView({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditHotelViewModel()..init(hotel),
      child: Consumer<EditHotelViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              title: const Text(
                'Edit Hotel',
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: const IconThemeData(color: AppColors.black),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: AppPadding.formVertical,
                horizontal: AppPadding.formHorizontal,
              ),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Hotel Details',
                      style: TextStyle(
                        fontSize: AppFontSizes.title,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _textField(viewModel.nameCtrl, 'Hotel Name'),
                    const SizedBox(height: AppSpacing.medium),
                    DropdownButtonFormField<String>(
                      value:
                          viewModel.cities.contains(viewModel.selectedLocation)
                              ? viewModel.selectedLocation
                              : null,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          viewModel.cities
                              .toSet() 
                              .map(
                                (city) => DropdownMenuItem(
                                  value: city,
                                  child: Text(city),
                                ),
                              )
                              .toList(),
                      onChanged: viewModel.setLocation,
                      validator:
                          (val) =>
                              val == null || val.isEmpty
                                  ? 'Select a city'
                                  : null,
                    ),

                    const SizedBox(height: AppSpacing.medium),
                    _textField(
                      viewModel.priceCtrl,
                      'Price',
                      type: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    _textField(
                      viewModel.descriptionCtrl,
                      'Short Description',
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    _textField(
                      viewModel.detailsCtrl,
                      'Detailed Info',
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    _textField(viewModel.imagesCtrl, 'Cover Image URL'),
                    const SizedBox(height: AppSpacing.medium),
                    const Text(
                      'Facilities',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: AppSpacing.small,
                      runSpacing: AppSpacing.small,
                      children:
                          viewModel.facilityOptions.map((facility) {
                            final label = facility['label'] as String;
                            final icon = facility['icon'] as IconData;
                            final isSelected = viewModel.selectedFacilities
                                .contains(label);
                            return FilterChip(
                              showCheckmark: false,
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    icon,
                                    size: 18,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    label,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              selected: isSelected,
                              onSelected:
                                  (_) => viewModel.toggleFacility(label),
                              backgroundColor: AppColors.white,
                              selectedColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppBorderRadius.card,
                                ),
                                side: const BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.section),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => viewModel.updateHotel(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppPadding.buttonVertical,
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: AppColors.primary,
                                  width: 0.5,
                                ),

                                borderRadius: BorderRadius.circular(
                                  AppBorderRadius.card,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Update Hotel',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _confirmDelete(context, viewModel),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppPadding.buttonVertical,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppBorderRadius.card,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Delete Hotel',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    EditHotelViewModel viewModel,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete this hotel?\nThis cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
    if (confirmed == true) await viewModel.deleteHotel(context);
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    TextInputType? type,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Enter $label' : null,
    );
  }
}
