import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/screens/admin/viewmodels/add_event_viewmodel.dart';

class AddEventView extends StatelessWidget {
  const AddEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddEventViewModel()..initRoleAndOrganizers(),
      child: Consumer<AddEventViewModel>(
        builder: (context, viewModel, _) {
          final screenWidth = MediaQuery.of(context).size.width;
          final containerWidth = screenWidth < 700 ? screenWidth * 0.9 : 600.0;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              title: const Text(
                'Add Event',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Container(
                  width: containerWidth,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                          'Add Event Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _textField(viewModel.nameCtrl, 'Event Name'),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: viewModel.selectedLocation,
                          items:
                              viewModel.cities.map((city) {
                                return DropdownMenuItem(
                                  value: city,
                                  child: Text(city),
                                );
                              }).toList(),
                          onChanged: viewModel.setLocation,
                          decoration: const InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (val) => val == null ? 'Select a city' : null,
                        ),
                        if (viewModel.isAdmin) ...[
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: viewModel.selectedOrganizerId,
                            items:
                                viewModel.organizers.map((org) {
                                  return DropdownMenuItem<String>(
                                    value: org['uid'].toString(),
                                    child: Text(
                                      (org['name'] ?? 'Unnamed').toString(),
                                    ),
                                  );
                                }).toList(),
                            onChanged: viewModel.setOrganizer,
                            decoration: const InputDecoration(
                              labelText: 'Assign to Organizer',
                              border: OutlineInputBorder(),
                            ),
                            validator:
                                (val) =>
                                    val == null ? 'Select organizer' : null,
                          ),
                        ],
                        const SizedBox(height: 16),
                        _textField(
                          viewModel.priceCtrl,
                          'Price',
                          type: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _textField(
                          viewModel.limiteCtrl,
                          'Available Tickets',
                          type: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _textField(
                          viewModel.descriptionCtrl,
                          'Short Description',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        _textField(
                          viewModel.detailsCtrl,
                          'Detailed Info',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        _textField(viewModel.imageCtrl, 'Image URL'),
                        const SizedBox(height: 16),
                        _textField(viewModel.dateCtrl, 'Date (yyyy-MM-dd)'),
                        const SizedBox(height: 16),
                        _textField(viewModel.timeCtrl, 'Time (e.g. 7:00pm)'),
                        const SizedBox(height: 16),
                        _textField(
                          viewModel.highlightsCtrl,
                          'Highlights (comma separated)',
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Is Favorite?'),
                          value: viewModel.isFavorite,
                          onChanged: viewModel.setFavorite,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => viewModel.submitEvent(context),
                            child: const Text(
                              'Add Event',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
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
