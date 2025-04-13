import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  int selectedTab = 0; // 0 = Active, 1 = Completed, 2 = Cancel
  List<Map<String, dynamic>> activeOrders = [
    {"title": "Watch", "brand": "Rolex", "price": "\$40", "image": "assets/Watch.png"},
    {"title": "Airpods", "brand": "Apple", "price": "\$333", "image": "assets/Airpods.png"},
    {"title": "Hoodie", "brand": "Puma", "price": "\$50", "image": "assets/Hoodie.png"},
  ];

  void cancelOrder(int index) {
    setState(() {
      activeOrders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildTab("Active", 0),
                buildTab("Completed", 1),
                buildTab("Cancel", 2),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: activeOrders.length,
              itemBuilder: (context, index) {
                final order = activeOrders[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(order["image"], width: 70, height: 70, fit: BoxFit.cover),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order["title"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(order["brand"]),
                            Text(order["price"], style: const TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                      selectedTab == 2
                          ? ElevatedButton(
                              onPressed: () => cancelOrder(index),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                              child: const Text("Cancel"),
                            )
                          : ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                              child: const Text("Track Order"),
                            ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildTab(String label, int tabIndex) {
    final isSelected = selectedTab == tabIndex;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = tabIndex),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 24,
              color: Colors.deepPurple,
            ),
        ],
      ),
    );
  }
}
