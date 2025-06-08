import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/admin/viewmodels/add_hotel_viewmodel.dart';

class AddHotelView extends StatelessWidget {
  final bool assignToCurrentManager;
  const AddHotelView({super.key, this.assignToCurrentManager = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddHotelViewModel()..loadHotelManagers(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: const Text('Add Hotel', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: AppColors.black),
          elevation: 0,
        ),
        body: Consumer<AddHotelViewModel>(
          builder: (context, viewModel, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: AppPadding.formVertical,
                horizontal: AppPadding.formHorizontal,
              ),
              child: Center(
                child: Container(
                  width: AppDimensions.formWidth,
                  padding: const EdgeInsets.all(AppPadding.containerPadding),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppBorderRadius.card),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: AppShadows.cardBlur),
                    ],
                  ),
                  child: Form(
                    key: viewModel.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Add Hotel Details', style: TextStyle(fontSize: AppFontSizes.title, fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppSpacing.large),
                        _buildTextField(viewModel.nameCtrl, 'Hotel Name'),
                        const SizedBox(height: AppSpacing.medium),
                        DropdownButtonFormField<String>(
                          value: viewModel.selectedLocation,
                          items: viewModel.cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                          onChanged: viewModel.setLocation,
                          decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
                          validator: (value) => value == null || value.isEmpty ? 'Select a city' : null,
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        _buildTextField(viewModel.priceCtrl, 'Price', keyboardType: TextInputType.number),
                        const SizedBox(height: AppSpacing.medium),
                        _buildTextField(viewModel.descriptionCtrl, 'Short Description', maxLines: 2),
                        const SizedBox(height: AppSpacing.medium),
                        _buildTextField(viewModel.detailsCtrl, 'Detailed Info', maxLines: 3),
                        const SizedBox(height: AppSpacing.medium),
                        _buildTextField(viewModel.imagesCtrl, 'Cover Image URL'),
                        const SizedBox(height: AppSpacing.medium),
                        const Text('Facilities', style: TextStyle(fontWeight: FontWeight.bold)),
                        Wrap(
                          spacing: AppSpacing.small,
                          runSpacing: AppSpacing.small,
                          children: viewModel.facilityOptions.map((facility) {
                            final isSelected = viewModel.selectedFacilities.contains(facility['label']);
                            return FilterChip(
                              showCheckmark: false,
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(facility['icon'], size: 18, color: isSelected ? Colors.white : AppColors.primary),
                                  const SizedBox(width: 6),
                                  Text(facility['label'], style: TextStyle(color: isSelected ? Colors.white : AppColors.primary)),
                                ],
                              ),
                              selected: isSelected,
                              onSelected: (_) => viewModel.toggleFacility(facility['label']),
                              backgroundColor: AppColors.white,
                              selectedColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppBorderRadius.card),
                                side: const BorderSide(color: AppColors.primary),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        SwitchListTile(
                          title: const Text('Is Favorite?'),
                          value: viewModel.isFavorite,
                          onChanged: viewModel.setFavorite,
                        ),
                        if (!assignToCurrentManager)
                          Column(
                            children: [
                              const SizedBox(height: AppSpacing.medium),
                              DropdownButtonFormField<String>(
                                value: viewModel.selectedManagerId,
                                decoration: const InputDecoration(
                                  labelText: 'Assign Hotel Manager',
                                  border: OutlineInputBorder(),
                                ),
                                items: viewModel.hotelManagers.map((manager) {
                                  return DropdownMenuItem<String>(
                                    value: manager['uid'],
                                    child: Text(manager['name']),
                                  );
                                }).toList(),
                                onChanged: viewModel.setManager,
                                validator: (value) => value == null || value.isEmpty ? 'Please select a manager' : null,
                              ),
                            ],
                          ),
                        const SizedBox(height: AppSpacing.section),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: AppPadding.buttonVertical),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.card)),
                            ),
                            onPressed: () => viewModel.submitHotel(assignToCurrentManager, context),
                            child: const Text('Add Hotel', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white)),
                          ),
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

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
    );
  }
}
