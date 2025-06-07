import 'package:flutter/material.dart';
import 'package:staypal/screens/admin/services/user_service.dart';
import 'package:staypal/models/user_model.dart';
import 'package:staypal/screens/admin/views/user_details_view.dart';

class ListUsersView extends StatefulWidget {
  const ListUsersView({super.key});

  @override
  State<ListUsersView> createState() => _ListUsersViewState();
}

class _ListUsersViewState extends State<ListUsersView> {
  final userService = UserService();
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchCtrl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        return user.fullName.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query) ||
            user.phone.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _loadUsers() async {
    final users = await userService.fetchUsers();
    setState(() {
      _allUsers = users;
      _filteredUsers = users;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchCtrl,
            decoration: const InputDecoration(
              hintText: 'Search by name, email, or phone',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(child: Text('No users found.'))
                : ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserDetailsView(user: user),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: user.imageUrl.isNotEmpty
                          ? NetworkImage(user.imageUrl)
                          : null,
                      child: user.imageUrl.isEmpty
                          ? Text(user.fullName.isNotEmpty ? user.fullName[0] : '?')
                          : null,
                    ),
                    title: Text(user.fullName),
                    subtitle: Text(user.email),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(user.phone),
                        const SizedBox(height: 4),
                        Text(user.city, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}