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

  final int userId = 1; // Simulated logged-in user
  String firstName = 'Mark';
  String lastName = 'Adam';
  String username = '@Mark';
  String email = 'Sunny_Koelpin45@hotmail.com';
  String phone = '+234 904 6470';
  String selectedGender = 'Female';
  String selectedBirthYear = '1998';

  final List<String> genders = ['Female', 'Male', 'Other'];
  final List<String> birthYears = [for (int i = 1960; i <= 2023; i++) i.toString()];

  Future<void> updateUserProfile() async {
    final updatedData = {
      'email': email,
      'username': username,
      'name': {'firstname': firstName, 'lastname': lastName},
      'phone': phone,
    };

    try {
      await _apiService.updateProfile(userId, updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context); // Go back to Profile page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundImage: AssetImage("assets/profile.jpg")),
            const SizedBox(height: 20),
            const Text('Edit Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTextField('First Name', firstName, (val) => firstName = val),
                  buildTextField('Last Name', lastName, (val) => lastName = val),
                  buildTextField('Username', username, (val) => username = val),
                  buildTextField('Email', email, (val) => email = val),
                  buildTextField('Phone Number', phone, (val) => phone = val),
                  const SizedBox(height: 16),
                  buildDropdown('Birth Year', selectedBirthYear, birthYears, (val) => selectedBirthYear = val!),
                  const SizedBox(height: 16),
                  buildDropdown('Gender', selectedGender, genders, (val) => selectedGender = val!),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text("Update Profile"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onPressed: updateUserProfile,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, String initialValue, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            onChanged: onChanged,
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          ),
        ),
      ),
    );
  }
}
