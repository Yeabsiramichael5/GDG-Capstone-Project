import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'services/api_service.dart';




class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final int userId = 1; // Replace this with the actual logged-in user ID

  // User fields
  String firstName = 'Mark';
  String lastName = 'Adam';
  String username = '@Mark';
  String email = 'Sunny_Koelpin45@hotmail.com';
  String phone = '+234 904 6470';
  String selectedGender = 'Female';
  String selectedBirthYear = '1998';

  final List<String> genders = ['Female', 'Male', 'Other'];
  final List<String> birthYears = [
    for (int i = 1960; i <= 2023; i++) i.toString()
  ];

  Future<void> updateUserProfile() async {
    final updatedData = {
      'email': email,
      'username': username,
      'name': {
        'firstname': firstName,
        'lastname': lastName,
      },
      'phone': phone,
    };

    final url = Uri.parse('https://fakestoreapi.com/users/$userId');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        print("Response: ${response.body}");
      } else {
        throw Exception("Failed to update: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.deepPurpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/profile.jpg"),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTextField(
                    label: 'First Name',
                    initialValue: firstName,
                    onChanged: (val) => firstName = val,
                  ),
                  buildTextField(
                    label: 'Last Name',
                    initialValue: lastName,
                    onChanged: (val) => lastName = val,
                  ),
                  buildTextField(
                    label: 'Username',
                    initialValue: username,
                    onChanged: (val) => username = val,
                  ),
                  buildTextField(
                    label: 'Email',
                    initialValue: email,
                    onChanged: (val) => email = val,
                  ),
                  buildTextField(
                    label: 'Phone Number',
                    initialValue: phone,
                    onChanged: (val) => phone = val,
                  ),
                  const SizedBox(height: 16),
                  buildDropdown('Birth', selectedBirthYear, birthYears, (val) {
                    setState(() => selectedBirthYear = val!);
                  }),
                  const SizedBox(height: 16),
                  buildDropdown('Gender', selectedGender, genders, (val) {
                    setState(() => selectedGender = val!);
                  }),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002366),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.lock, color: Colors.white),
                    label: const Text(
                      "Update Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      updateUserProfile();
                    },
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

  Widget buildTextField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
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

  Widget buildDropdown(
      String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Row(
      children: [
        Expanded(
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
                items: items.map((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
