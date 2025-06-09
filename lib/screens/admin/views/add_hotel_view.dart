import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/screens/admin/viewmodels/add_hotel_viewmodel.dart';

class AddHotelView extends StatefulWidget {
  final bool assignToCurrentManager;
  const AddHotelView({super.key, this.assignToCurrentManager = false});

  @override
  State<AddHotelView> createState() => _AddHotelViewState();
}

class _AddHotelViewState extends State<AddHotelView> {
  late AddHotelViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AddHotelViewModel();
    _viewModel.initialize(widget.assignToCurrentManager);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    try {
      final success = await _viewModel.submitHotel(widget.assignToCurrentManager);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hotel added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddHotelViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            'Add Hotel',
            style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: AppColors.black),
          elevation: 0,
        ),
        body: Consumer<AddHotelViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

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
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: AppShadows.cardBlur,
                      ),
                    ],
                  ),
                  child: Form(
                    key: viewModel.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add Hotel Details',
                          style: TextStyle(
                            fontSize: AppFontSizes.title,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.large),
                        _buildTextField(
                          viewModel.nameController,
                          'Hotel Name',
                          viewModel,
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        _buildLocationDropdown(viewModel),
                        const SizedBox(height: AppSpacing.medium),
                        _buildTextField(
                          viewModel.priceController,
                          'Price',
                          viewModel,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        _buildTextField(
                          viewModel.descriptionController,
                          'Short Description',
                          viewModel,
                          maxLines: 2,
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        _buildTextField(
                          viewModel.detailsController,
                          'Detailed Info',
                          viewModel,
                          maxLines: 3,
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        _buildTextField(
                          viewModel.imagesController,
                          'Cover Image URL',
                          viewModel,
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        _buildFacilitiesSection(viewModel),
                        const SizedBox(height: AppSpacing.medium),
                        if (!widget.assignToCurrentManager)
                          _buildManagerDropdown(viewModel),
                        const SizedBox(height: AppSpacing.section),
                        _buildSubmitButton(viewModel),
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    AddHotelViewModel viewModel, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => viewModel.validateField(value, label),
    );
  }

  Widget _buildLocationDropdown(AddHotelViewModel viewModel) {
    return DropdownButtonFormField<String>(
      value: viewModel.selectedLocation,
      items: viewModel.cities
          .map(
            (city) => DropdownMenuItem(
              value: city,
              child: Text(city),
            ),
          )
          .toList(),
      onChanged: viewModel.updateSelectedLocation,
      decoration: const InputDecoration(
        labelText: 'City',
        border: OutlineInputBorder(),
      ),
      validator: (value) => viewModel.validateDropdown(value, 'Select a city'),
    );
  }

  Widget _buildFacilitiesSection(AddHotelViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Facilities',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.small),
        Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          children: viewModel.facilityOptions.map((facility) {
            final isSelected = viewModel.isFacilitySelected(facility['label']);
            return FilterChip(
              showCheckmark: false,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    facility['icon'],
                    size: 18,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    facility['label'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
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
      ],
    );
  }

 

  Widget _buildManagerDropdown(AddHotelViewModel viewModel) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.medium),
        DropdownButtonFormField<String>(
          value: viewModel.selectedManagerId,
          decoration: const InputDecoration(
            labelText: 'Assign Hotel Manager',
            border: OutlineInputBorder(),
          ),
          items: viewModel.hotelManagers
              .map(
                (manager) => DropdownMenuItem<String>(
                  value: manager['uid'],
                  child: Text(manager['name'] ?? 'Unnamed'),
                ),
              )
              .toList(),
          onChanged: viewModel.updateSelectedManager,
          validator: (value) => viewModel.validateDropdown(
            value,
            'Please select a manager',
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AddHotelViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
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
        onPressed: viewModel.isLoading ? null : _handleSubmit,
        child: viewModel.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Add Hotel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }
}