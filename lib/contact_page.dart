import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Us")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Contact Us",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Any questions or remarks? Just write us a message!"),

            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter a valid email address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("SUBMIT"),
            ),
            const SizedBox(height: 40),

            // Bottom info section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _ContactInfo(icon: Icons.directions_run, title: "Abou App", subtitle: "Shopping App\nLast Group"),
                _ContactInfo(icon: Icons.phone, title: "PHONE", subtitle: "0912345678\n0987654321"),
                _ContactInfo(icon: Icons.location_on, title: "LOCATION", subtitle: "AASTU,\nAddis Ababa, Ethiopia"),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ContactInfo({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(backgroundColor: Colors.teal, child: Icon(icon, color: Colors.white)),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, textAlign: TextAlign.center),
      ],
    );
  }
}
