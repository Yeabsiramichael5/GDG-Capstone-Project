import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareAppPage extends StatelessWidget {
  const ShareAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Share App")),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Share.share('Check out this awesome app! https://your-app-link.com');
          },
          icon: const Icon(Icons.share),
          label: const Text("Share App"),
        ),
      ),
    );
  }
}
