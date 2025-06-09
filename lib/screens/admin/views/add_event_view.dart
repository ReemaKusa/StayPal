import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/screens/admin/viewmodels/add_event_viewmodel.dart';

class AddEventView extends StatelessWidget {
  const AddEventView({super.key});

  static const double kPadding = 16.0;
  static const double kCardRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddEventViewModel()..loadRoleAndOrganizers(),
      child: Consumer<AddEventViewModel>(
        builder: (context, viewModel, _) {
          final screenWidth = MediaQuery.of(context).size.width;
          final containerWidth = screenWidth < 700 ? screenWidth * 0.9 : 600.0;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              iconTheme: const IconThemeData(color: Colors.black),
              title: const Text('Add Event',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Container(
                  width: containerWidth,
                  padding: const EdgeInsets.all(kPadding + 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(kCardRadius),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: AppShadows.cardBlur),
                    ],
                  ),
                  child: Form(
                    key: viewModel.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Add Event Details',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        _textField(viewModel.nameCtrl, 'Event Name'),
                        _dropdown(viewModel),
                        if (viewModel.isAdmin) _organizerDropdown(viewModel),
                        _textField(viewModel.priceCtrl, 'Price', type: TextInputType.number),
                        _textField(viewModel.limiteCtrl, 'Available Tickets', type: TextInputType.number),
                        _textField(viewModel.descriptionCtrl, 'Short Description', lines: 2),
                        _textField(viewModel.detailsCtrl, 'Detailed Info', lines: 3),
                        _textField(viewModel.imageCtrl, 'Image URL'),
                        _textField(viewModel.dateCtrl, 'Date (yyyy-MM-dd)'),
                        _textField(viewModel.timeCtrl, 'Time (e.g. 7:00pm)'),
                        _textField(viewModel.highlightsCtrl, 'Highlights (comma separated)'),
                        SwitchListTile(
                          title: const Text('Is Favorite?'),
                          value: viewModel.isFavorite,
                          onChanged: (val) => viewModel.isFavorite = val,
                        ),
                        const SizedBox(height: kPadding + 4),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              
                              backgroundColor: Colors.deepOrange,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                
                                borderRadius: BorderRadius.circular(kCardRadius),
                                
                              ),
                            ),
                            onPressed: () => viewModel.submitEvent(context),
                            child: const Text('Add Event',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _textField(TextEditingController ctrl, String label,
      {TextInputType type = TextInputType.text, int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        maxLines: lines,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: (value) => value!.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  Widget _dropdown(AddEventViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: vm.selectedLocation,
        items: vm.cities.map((city) {
          return DropdownMenuItem(value: city, child: Text(city));
        }).toList(),
        onChanged: (val) => vm.selectedLocation = val,
        decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
        validator: (val) => val == null || val.isEmpty ? 'Select a city' : null,
      ),
    );
  }

  Widget _organizerDropdown(AddEventViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: vm.selectedOrganizerId,
        items: vm.organizers.map((org) {
          return DropdownMenuItem(value: org['uid'], child: Text(org['name'] ?? 'Unnamed'));
        }).toList(),
        onChanged: (val) => vm.selectedOrganizerId = val,
        decoration: const InputDecoration(
            labelText: 'Assign to Event Organizer', border: OutlineInputBorder()),
        validator: (val) => val == null ? 'Select an organizer' : null,
      ),
    );
  }
}
