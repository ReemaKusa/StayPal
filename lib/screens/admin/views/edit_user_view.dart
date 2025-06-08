import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
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
  final List<String> _roles = [
    'user',
    'admin',
    'hotel_manager',
    'event_organizer',
  ];

  String? selectedGender;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.fullName);
    _phoneCtrl = TextEditingController(text: widget.user.phone);
    _cityCtrl = TextEditingController(text: widget.user.city);
    _zipCtrl = TextEditingController(text: widget.user.zipCode);
    _countryCtrl = TextEditingController(text: widget.user.country);
    selectedGender = widget.user.gender;
    _selectedRole = widget.user.role;
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
        'gender': selectedGender ?? '',
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
        const SnackBar(content: Text(' User updated successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit User',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSizes.title,
          ),
        ),
        backgroundColor: AppColors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppPadding.formVertical),
          children: [
            _buildField(_nameCtrl, 'Full Name'),
            _buildField(_phoneCtrl, 'Phone'),
            _buildField(_cityCtrl, 'City'),
            _buildGenderDropdown(),
            _buildField(_zipCtrl, 'Zip Code'),
            _buildField(_countryCtrl, 'Country'),
            _buildRoleDropdown(),
            const SizedBox(height: AppSpacing.large),
            ElevatedButton(
              onPressed: _updateUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.greyTransparent),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.card),
                ),
              ),
              child: const Text('Save Changes'),
            ),
          ],
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.card),
            borderSide: const BorderSide(color: AppColors.greyTransparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.card),
            borderSide: const BorderSide(color: AppColors.greyTransparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.card),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        validator:
            (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: GestureDetector(
        onTap: () {
          selectGender(context, () {
            setState(() {});
          });
        },
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Gender',
              hintText: selectedGender ?? 'Select Gender',
              labelStyle: const TextStyle(color: AppColors.black),
              hintStyle: const TextStyle(color: AppColors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.card),
                borderSide: const BorderSide(color: AppColors.greyTransparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.card),
                borderSide: const BorderSide(color: AppColors.greyTransparent),
              ),
            ),
            controller: TextEditingController(text: selectedGender),
            validator:
                (value) =>
                    (selectedGender == null || selectedGender!.isEmpty)
                        ? 'Required'
                        : null,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _roles.contains(_selectedRole) ? _selectedRole : _roles.first,
        decoration: InputDecoration(
          labelText: 'Role',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.card),
            borderSide: BorderSide(color: AppColors.greyTransparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.card),
            borderSide: const BorderSide(color: AppColors.greyTransparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.card),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        items:
            _roles.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  child: Text(
                    role,
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
              );
            }).toList(),
        onChanged: (value) => setState(() => _selectedRole = value),
        validator:
            (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  void selectGender(BuildContext context, VoidCallback onUpdate) {
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: AppSizes.sizedbox,
              child: Column(
                children: [
                  RadioListTile<String>(
                    activeColor: AppColors.primary,
                    title: const Text(
                      "Male",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.subtitle,
                      ),
                    ),
                    value: 'Male',
                    groupValue: selectedGender,
                    onChanged:
                        (value) => setModalState(() => selectedGender = value),
                  ),
                  RadioListTile<String>(
                    activeColor: AppColors.primary,
                    title: const Text(
                      "Female",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.subtitle,
                      ),
                    ),
                    value: 'Female',
                    groupValue: selectedGender,
                    onChanged:
                        (value) => setModalState(() => selectedGender = value),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppPadding.formHorizontal),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppBorderRadius.card,
                          ),
                        ),
                        side: const BorderSide(
                          color: AppColors.greyTransparent,
                        ),
                      ),
                      onPressed: () async {
                        if (selectedGender != null) {
                          onUpdate();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: AppFontSizes.subtitle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
