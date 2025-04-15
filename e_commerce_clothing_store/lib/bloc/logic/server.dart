import 'package:e_commerce_clothing_store/bloc/data/model/card_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Server {
  static Future<List<CardModel>?> fetchData(String? tag) async {
    try {
      final uri = Uri.parse('http://10.2.75.82:3456/products');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        print('/what a wonderful day/');
        print('/what a wonderful day/');
        print('/what a wonderful day/');
        print('/what a wonderful day/');

        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => CardModel.fromJson(item)).toList();
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  static Future<void> likeProduct(String? productId) async {
    //! before liking the product we have to map the product 
    //! with the user so that it could be saved under the users name.
    try {
      final uri = Uri.parse('http://localhost:3456/likes');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'productId': productId}),
      );

      if (response.statusCode == 201) {
        print('Product liked successfully.');
      } else {
        print('Failed to like product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error liking product: $e');
    }
  }
}
