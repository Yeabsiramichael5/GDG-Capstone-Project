import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://fakestoreapi.com';

  // Fetch user profile from FakeStore API
  Future<Map<String, dynamic>> fetchProfile() async {
    final url = Uri.parse('$baseUrl/users/1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // Optional: update profile
  Future<void> updateProfile(Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$baseUrl/users/1');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }
}
