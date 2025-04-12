import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const Text("Account", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("assets/profile.jpg"),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mark Adam", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "Sunny_Koelpin45@hotmail.com",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text("Setting", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          settingItem(icon: Icons.notifications, title: "Notification"),
          settingItem(icon: Icons.language, title: "Language", trailing: const Text("English")),
          settingItem(icon: Icons.lock_outline, title: "Privacy"),
          settingItem(icon: Icons.help_outline, title: "Help Center"),
          settingItem(icon: Icons.info_outline, title: "About us"),
        ],
      ),
    );
  }

  Widget settingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 20),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
          trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
