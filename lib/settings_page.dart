import 'package:flutter/material.dart';
import 'profile';
import 'profile.dart';
import 'notification_page.dart';
import 'language_page.dart';
import 'privacy_page.dart';
import 'help_page.dart';
import 'about_us_page.dart';

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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
            child: Container(
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
          ),
          const SizedBox(height: 30),
          const Text("Setting", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // Navigation List Items
          settingItem(
            icon: Icons.notifications,
            title: "Notification",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage()));
            },
          ),
          settingItem(
            icon: Icons.language,
            title: "Language",
            trailing: const Text("English"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguagePage()));
            },
          ),
          settingItem(
            icon: Icons.lock_outline,
            title: "Privacy",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPage()));
            },
          ),
          settingItem(
            icon: Icons.help_outline,
            title: "Help Center",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpPage()));
            },
          ),
          settingItem(
            icon: Icons.info_outline,
            title: "About us",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsPage()));
            },
          ),
        ],
      ),
    );
  }

  Widget settingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
