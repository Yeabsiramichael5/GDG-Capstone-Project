import 'package:flutter/material.dart';
import 'main_order.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: CheckoutPage());
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPaymentMethod = 'Credit Card';
  final Color customBlue = Color(0xFF2A3F78);
  String location = '325 15th Eighth Avenue, NewYork';
  String deliveryTime = '6:00 pm, Wednesday 20';
  final TextEditingController locationController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  int itemCount = 0;
  double subtotal = 0.0;
  double discount = 4.0;
  double deliveryCharge = 2.0;
  List<Map<String, dynamic>> orders = [];

  double get total => subtotal - discount + deliveryCharge;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      subtotal = arguments['subtotal'] ?? 0.0;
      itemCount = arguments['itemCount'] ?? 0;
      orders = arguments['orders'] ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Check Out',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () async {
                      String? newLocation = await _showLocationDialog();
                      if (newLocation != null && newLocation.isNotEmpty) {
                        setState(() {
                          location = newLocation;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.location_pin, color: customBlue),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Saepe eaque fugiat ea voluptatum veniam.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                    onTap: () async {
                      String? newTime = await _showTimeDialog();
                      if (newTime != null && newTime.isNotEmpty) {
                        setState(() {
                          deliveryTime = newTime;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: customBlue),
                        SizedBox(width: 10),
                        Text(
                          deliveryTime,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        _orderSummaryRow('Items', '$itemCount'),
                        SizedBox(height: 4),
                        _orderSummaryRow(
                          'Subtotal',
                          '\$${subtotal.toStringAsFixed(2)}',
                        ),
                        SizedBox(height: 4),
                        _orderSummaryRow(
                          'Discount',
                          '-\$${discount.toStringAsFixed(2)}',
                        ),
                        SizedBox(height: 4),
                        _orderSummaryRow(
                          'Delivery Charges',
                          '\$${deliveryCharge.toStringAsFixed(2)}',
                        ),
                        Divider(),
                        _orderSummaryRow(
                          'Total',
                          '\$${total.toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Choose payment method',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  _paymentMethodTile(Icons.paypal, 'Paypal'),
                  _paymentMethodTile(Icons.credit_card, 'Credit Card'),
                  _paymentMethodTile(Icons.money, 'Cash'),
                  ListTile(
                    leading: Icon(Icons.add_circle_outline, color: Colors.grey),
                    title: Text(
                      'Add new payment method',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      _showAddPaymentMethodDialog();
                    },
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OrdersPage(),
                            settings: RouteSettings(
                              arguments: {'orders': orders},
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004AAD),
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _orderSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _paymentMethodTile(IconData icon, String title) {
    bool selected = selectedPaymentMethod == title;
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      ),
      trailing: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? customBlue : Colors.grey,
      ),
      onTap: () {
        setState(() {
          selectedPaymentMethod = title;
        });
        if (title != 'Cash') {
          _showPaymentMethodDialog(title);
        }
      },
    );
  }

  Future<String?> _showLocationDialog() async {
    locationController.text = location;
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter your location'),
          content: TextField(
            controller: locationController,
            decoration: InputDecoration(hintText: 'Enter new location'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed:
                  () => Navigator.of(context).pop(locationController.text),
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showTimeDialog() async {
    timeController.text = deliveryTime;
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter delivery time'),
          content: TextField(
            controller: timeController,
            decoration: InputDecoration(hintText: 'Enter new time'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(timeController.text),
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentMethodDialog(String method) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter your $method details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(decoration: InputDecoration(hintText: 'Name')),
              TextField(
                decoration: InputDecoration(hintText: 'Account number'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select payment method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Digital Wallets'),
                onTap: () => _showPaymentDetailsDialog('Digital Wallets'),
              ),
              ListTile(
                title: Text('Bank Transfer'),
                onTap: () => _showPaymentDetailsDialog('Bank Transfer'),
              ),
              ListTile(
                title: Text('Cryptocurrency'),
                onTap: () => _showPaymentDetailsDialog('Cryptocurrency'),
              ),
              ListTile(
                title: Text('BNPL (Buy Now, Pay Later)'),
                onTap: () => _showPaymentDetailsDialog('BNPL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentDetailsDialog(String method) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter your $method details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(decoration: InputDecoration(hintText: 'Name')),
              TextField(
                decoration: InputDecoration(hintText: 'Account number'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
