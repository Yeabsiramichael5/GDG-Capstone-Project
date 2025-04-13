import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Product> _products = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _error;
  
  List<Product> get products => _products;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> fetchAllProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _products = await _apiService.getAllProducts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _categories = await _apiService.getCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> fetchProductsByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _products = await _apiService.getProductsByCategory(category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<Product?> getProductById(int id) async {
    try {
      return await _apiService.getProduct(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
