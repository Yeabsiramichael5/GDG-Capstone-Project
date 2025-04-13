import 'package:dio/dio.dart';
import '../models/product.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com'));

  Future<List<Product>> fetchProducts() async {
    final response = await _dio.get('/products');
    if (response.statusCode == 200) {
      List<dynamic> data = response.data as List<dynamic>;
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}
