import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'edit_profile_page.dart';
import 'order_history_page.dart';
import 'settings_page.dart';
import 'contact_page.dart';
import 'share_app_page.dart';
import 'help_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService _apiService = ApiService();

  String firstName = '';
  String lastName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    try {
      final profile = await _apiService.fetchProfile(userId: 1);
      setState(() {
        firstName = profile['name']['firstname'] ?? '';
        lastName = profile['name']['lastname'] ?? '';
        email = profile['email'] ?? '';
      });
    } catch (e) {
      debugPrint('Failed to load profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryPage()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(radius: 50, backgroundImage: AssetImage("assets/profile.jpg")),
              const SizedBox(height: 16),
              Text("$firstName $lastName", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(email, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 30),
              buildMenuItem(Icons.person, "Edit Profile", () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage()));
                _loadProfile();
              }),
              buildMenuItem(Icons.settings, "Setting", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
              }),
              buildMenuItem(Icons.mail, "Contact", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactPage()));
              }),
              buildMenuItem(Icons.share, "Share App", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ShareAppPage()));
              }),
              buildMenuItem(Icons.help_outline, "Help", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpPage()));
              }),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signed Out")));
                },
                child: const Text("Sign Out", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: const Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          elevation: 0,
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 20),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
