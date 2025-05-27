import 'package:flutter/material.dart';
import 'package:staypal/screens/profile/edit_address_screen.dart';
import 'package:staypal/screens/profile/edit_name_screen.dart';
import 'package:staypal/screens/profile/edit_phone_screen.dart';
import 'package:staypal/viewmodels/personal_details_viewmodel.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final viewModel = PersonalDetailsViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.fetchUserData().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Personal Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body:
          viewModel.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "We'll remember this info to make it faster when you book.",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  _buildTile("Name", viewModel.userData['fullName'] ?? '', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditNameScreen()),
                    ).then(
                      (_) => viewModel.fetchUserData().then(
                        (_) => setState(() {}),
                      ),
                    );
                  }),
                  _buildTile("Gender", viewModel.userData['gender'] ?? '', () {
                    viewModel.selectGender(context, () => setState(() {}));
                  }),
                  _buildTile(
                    "Date of birth",
                    viewModel.userData['dob'] ?? '',
                    () {
                      viewModel.pickDateOfBirth(context, () => setState(() {}));
                    },
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Contact details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Properties or providers you book with will use this info if they need to contact you.",
                  ),
                  const SizedBox(height: 20),
                  _buildTile(
                    "Email",
                    viewModel.userData['email'] ?? 'N/A',
                    null,
                  ),
                  _buildTile(
                    "Phone number",
                    viewModel.userData['phone'] ?? '',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditPhoneScreen(),
                        ),
                      ).then(
                        (_) => viewModel.fetchUserData().then(
                          (_) => setState(() {}),
                        ),
                      );
                    },
                  ),
                  _buildTile(
                    "Address",
                    viewModel.userData['address'] ?? '',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditAddressScreen(),
                        ),
                      ).then(
                        (_) => viewModel.fetchUserData().then(
                          (_) => setState(() {}),
                        ),
                      );
                    },
                  ),
                ],
              ),
    );
  }

  Widget _buildTile(String label, dynamic value, VoidCallback? onTap) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(value != null ? value.toString() : ''),
      trailing:
          onTap != null
              ? const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black,
              )
              : null,
      onTap: onTap,
    );
  }
}
