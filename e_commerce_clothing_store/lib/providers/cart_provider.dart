import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/cart.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Cart? _cart;
  List<Product> _cartProducts = [];
  bool _isLoading = false;
  String? _error;
  
  Cart? get cart => _cart;
  List<Product> get cartProducts => _cartProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  int get totalItems {
    if (_cart == null) return 0;
    return _cart!.products.fold(0, (sum, item) => sum + item.quantity);
  }
  
  double get totalPrice {
    if (_cartProducts.isEmpty) return 0;
    double total = 0;
    for (var product in _cartProducts) {
      final cartItem = _cart!.products.firstWhere(
        (item) => item.productId == product.id,
        orElse: () => CartProduct(productId: 0, quantity: 0),
      );
      total += product.price * cartItem.quantity;
    }
    return total;
  }
  
  Future<void> fetchUserCart(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final List<Cart> userCarts = await _apiService.getUserCarts(userId);
      if (userCarts.isNotEmpty) {
        // Get the most recent cart
        _cart = userCarts.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
        await _fetchCartProducts();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> _fetchCartProducts() async {
    if (_cart == null) return;
    
    _cartProducts = [];
    for (var item in _cart!.products) {
      try {
        final product = await _apiService.getProduct(item.productId);
        _cartProducts.add(product);
      } catch (e) {
        _error = 'Failed to load product: ${e.toString()}';
      }
    }
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
