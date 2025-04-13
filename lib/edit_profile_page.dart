import 'package:flutter/material.dart';
import 'services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  int userId = 1;
  String firstName = '';
  String lastName = '';
  String username = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Fetch the user data by passing the userId directly as a positional parameter
    final user = await _apiService.fetchProfile(userId);
    setState(() {
      firstName = user['name']['firstname'];
      lastName = user['name']['lastname'];
      username = user['username'];
      email = user['email'];
      phone = user['phone'];
    });
  }

  Future<void> _saveProfile() async {
    final updatedData = {
      'email': email,
      'username': username,
      'name': {
        'firstname': firstName,
        'lastname': lastName,
      },
      'phone': phone,
    };

    final success = await _apiService.updateUser(userId: userId, updatedData: updatedData);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField("First Name", firstName, (val) => firstName = val),
              buildTextField("Last Name", lastName, (val) => lastName = val),
              buildTextField("Username", username, (val) => username = val),
              buildTextField("Email", email, (val) => email = val),
              buildTextField("Phone", phone, (val) => phone = val),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text("Save Changes"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String value, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        onChanged: onChanged,
      ),
    );
  }
}
