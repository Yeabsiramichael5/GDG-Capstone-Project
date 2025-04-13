import 'package:flutter/material.dart';
import 'models/product.dart';
import 'services/api_service.dart';
import 'main_check_out.dart';

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
              if (value == 'Help') {
                showDialog(
                  context: context,
                  builder: (_) => const Dialog(child: HelpPage()),
                );
              }
            },
            itemBuilder:
                (BuildContext context) => [
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

// Help Page
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help Center")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "How can we help you?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "If you need any help, contact us",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: const [
                  _HelpCard(
                    icon: Icons.location_on,
                    title: "OUR MAIN OFFICE",
                    info: "AASTU, Kilinto Prison kef blo",
                  ),
                  _HelpCard(
                    icon: Icons.phone,
                    title: "PHONE",
                    info: "0912345678\n0987654321",
                  ),
                  _HelpCard(
                    icon: Icons.print,
                    title: "FAX",
                    info: "12345678900",
                  ),
                  _HelpCard(
                    icon: Icons.email,
                    title: "EMAIL",
                    info: "ethioshopping@gmail.com",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String info;

  const _HelpCard({
    required this.icon,
    required this.title,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.deepPurple),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(info, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
