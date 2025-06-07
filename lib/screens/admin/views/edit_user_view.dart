import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/user_model.dart';

class EditUserView extends StatefulWidget {
  final UserModel user;
  const EditUserView({super.key, required this.user});

  @override
  State<EditUserView> createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _zipCtrl;
  late TextEditingController _countryCtrl;

  final List<String> _genders = ['Male', 'Female'];
  final List<String> _roles = ['user', 'admin', 'hotel_manager', 'event_organizer'];

  String? _selectedGender;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.fullName);
    _phoneCtrl = TextEditingController(text: widget.user.phone);
    _cityCtrl = TextEditingController(text: widget.user.city);
    _zipCtrl = TextEditingController(text: widget.user.zipCode);
    _countryCtrl = TextEditingController(text: widget.user.country);
    _selectedGender = widget.user.gender;
    _selectedRole = widget.user.role; // Load current role
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _zipCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'fullName': _nameCtrl.text,
        'phone': _phoneCtrl.text,
        'city': _cityCtrl.text,
        'gender': _selectedGender ?? '',
        'zipCode': _zipCtrl.text,
        'country': _countryCtrl.text,
        'role': _selectedRole ?? 'user', 
        'updatedAt': DateTime.now(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ User updated successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Edit User')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField(_nameCtrl, 'Full Name'),
              _buildField(_phoneCtrl, 'Phone'),
              _buildField(_cityCtrl, 'City'),
              _buildGenderDropdown(),
              _buildField(_zipCtrl, 'Zip Code'),
              _buildField(_countryCtrl, 'Country'),
              _buildRoleDropdown(), // ✅ Insert role dropdown here
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _genders.contains(_selectedGender) ? _selectedGender : null,
        decoration: const InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(),
        ),
        items: _genders.map((gender) {
          return DropdownMenuItem(value: gender, child: Text(gender));
        }).toList(),
        onChanged: (value) => setState(() => _selectedGender = value),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _roles.contains(_selectedRole) ? _selectedRole : _roles.first,
        decoration: const InputDecoration(
          labelText: 'Role',
          border: OutlineInputBorder(),
        ),
        items: _roles.map((role) {
          return DropdownMenuItem(value: role, child: Text(role));
        }).toList(),
        onChanged: (value) => setState(() => _selectedRole = value),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
}