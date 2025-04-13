import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "We value your privacy. Your data will not be shared with any third party without your consent. "
          "All personal information is stored securely and encrypted.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
