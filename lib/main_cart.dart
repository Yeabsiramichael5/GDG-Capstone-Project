import 'package:flutter/material.dart';
import 'models/product.dart';
import 'services/api_service.dart';
import 'main_check_out.dart';
import 'main_order.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Cart Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CartScreen(),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> _products = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = true;

  final Map<int, int> _quantities = {};
  final Color darkBlue = const Color(0xFF004AAD);

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      _products = await _apiService.fetchProducts();
      for (var product in _products) {
        _quantities[product.id] = 1;
      }
    } catch (e) {
      print('Failed to fetch products: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _incrementQuantity(int productId) {
    setState(() {
      _quantities[productId] = (_quantities[productId] ?? 1) + 1;
    });
  }

  void _decrementQuantity(int productId) {
    setState(() {
      if ((_quantities[productId] ?? 1) > 1) {
        _quantities[productId] = (_quantities[productId] ?? 1) - 1;
      }
    });
  }

  void _removeItem(int productId) {
    setState(() {
      _products.removeWhere((p) => p.id == productId);
      _quantities.remove(productId);
    });
  }

  double get _subtotal {
    return _products.fold(
      0.0,
      (sum, item) => sum + (item.price * (_quantities[item.id] ?? 1)),
    );
  }

  int get _itemCount {
    return _quantities.values.fold(0, (sum, q) => sum + q);
  }

  double get _discount => 4.0;
  double get _deliveryCharge => 2.0;
  double get _total => _subtotal - _discount + _deliveryCharge;

  List<Map<String, dynamic>> _generateOrderData() {
    return _products.map((product) {
      return {
        'title': product.title,
        'brand': 'Brand',
        'price': product.price,
        'image': product.image,
        'status': 'Active',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'Settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              } else if (value == 'Help') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpPage()),
                );
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'Settings',
                    child: Text('Settings'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Help',
                    child: Text('Help'),
                  ),
                ],
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final item = _products[index];
                        final quantity = _quantities[item.id] ?? 1;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    item.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${item.price.toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: darkBlue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        onPressed:
                                            () => _decrementQuantity(item.id),
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                        splashRadius: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('$quantity'),
                                    const SizedBox(width: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: darkBlue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        onPressed:
                                            () => _incrementQuantity(item.id),
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        splashRadius: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeItem(item.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildOrderSummarySection(context),
                  ],
                ),
              ),
    );
  }

  Widget _buildOrderSummarySection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Order Summary',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Items'), Text('$_itemCount')],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text('\$${_subtotal.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Discount'),
                Text('-\$${_discount.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery Charges'),
                Text('\$${_deliveryCharge.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Text(
                  '\$${_total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final orders = _generateOrderData();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CheckoutPage(),
                    settings: RouteSettings(
                      arguments: {
                        'subtotal': _subtotal,
                        'itemCount': _itemCount,
                        'orders': orders,
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkBlue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Check Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: const Center(child: Text("Settings Page")),
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help")),
      body: const Center(child: Text("Help Page")),
    );
  }
}
