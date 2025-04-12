import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
                  Row(
                    children: [
                      Icon(Icons.location_pin, color: customBlue),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '325 15th Eighth Avenue, NewYork',
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
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: customBlue),
                      SizedBox(width: 10),
                      Text(
                        '6:00 pm, Wednesday 20',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
                        _orderSummaryRow('Items', '3'),
                        SizedBox(height: 4),
                        _orderSummaryRow('Subtotal', '\$423'),
                        SizedBox(height: 4),
                        _orderSummaryRow('Discount', '-\$4'),
                        SizedBox(height: 4),
                        _orderSummaryRow('Delivery Charges', '\$2'),
                        Divider(),
                        _orderSummaryRow('Total', '\$423', isTotal: true),
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
                    onTap: () {},
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // API call or navigation here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Check Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
      },
    );
  }
}
