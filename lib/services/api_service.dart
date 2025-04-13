import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  // Fetch user profile (using user ID 1 for now)
  Future<Map<String, dynamic>> fetchProfile(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  // Update user profile
  Future<bool> updateUser({
    required int userId,
    required Map<String, dynamic> updatedData,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );

    return response.statusCode == 200;
  }
}
