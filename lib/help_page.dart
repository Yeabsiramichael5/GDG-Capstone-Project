import 'package:flutter/material.dart';

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
            const Text("How can we help you?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              "If you need any help,contact us",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: const [
                  _HelpCard(icon: Icons.location_on, title: "OUR MAIN OFFICE", info: "AASTU, Kilinto Prison kef blo"),
                  _HelpCard(icon: Icons.phone, title: "PHONE", info: "0912345678\n0987654321"),
                  _HelpCard(icon: Icons.print, title: "FAX", info: "12345678900"),
                  _HelpCard(icon: Icons.email, title: "EMAIL", info: "DefNotAddingMyEmailHere@gmail.com"),
                ],
              ),
            )
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

  const _HelpCard({required this.icon, required this.title, required this.info});

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
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(info, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
