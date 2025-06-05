import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staypal/models/user_model.dart';
import 'package:staypal/screens/admin/views/edit_user_view.dart';

class UserDetailsView extends StatefulWidget {
  final UserModel user;
  const UserDetailsView({super.key, required this.user});

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  late bool isActive;
  late String userRole;

  @override
  void initState() {
    super.initState();
    isActive = widget.user.isActive;
    userRole = widget.user.role;
  }

  Future<void> _toggleUserActive(bool value) async {
    setState(() => isActive = value);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .update({'isActive': value});
  }

  Future<void> _toggleUserRole() async {
    final newRole = userRole == 'admin' ? 'user' : 'admin';

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .update({'role': newRole});

    setState(() {
      userRole = newRole;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Role updated to "$newRole"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('User Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Stack(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: user.imageUrl.isNotEmpty
                            ? NetworkImage(user.imageUrl)
                            : null,
                        child: user.imageUrl.isEmpty
                            ? Text(
                                user.fullName.isNotEmpty ? user.fullName[0] : '?',
                                style: const TextStyle(fontSize: 32),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildRow('Full Name', user.fullName),
                    _buildRow('Email', user.email),
                    _buildRow('Phone', user.phone),
                    _buildRow('Gender', user.gender),
                    _buildRow('DOB', user.dob),
                    const Divider(height: 32),
                    _buildRow('Address', user.address),
                    _buildRow('City', user.city),
                    _buildRow('Country', user.country),
                    _buildRow('Zip Code', user.zipCode),
                    const Divider(height: 32),
                    if (user.createdAt != null)
                      _buildRow('Created At', user.createdAt!.toLocal().toString().split(" ")[0]),
                    const Divider(height: 32),
                    SwitchListTile(
                      title: const Text('User is Active'),
                      value: isActive,
                      onChanged: _toggleUserActive,
                    ),
                    const Divider(height: 32),
                    Text('Current Role: $userRole',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _toggleUserRole,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            userRole == 'admin' ? Colors.redAccent : Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      child: Text(userRole == 'admin' ? 'Remove Admin' : 'Make Admin'),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditUserView(user: user),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}