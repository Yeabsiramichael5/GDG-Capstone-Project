import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile image
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/profile.jpg"), // <-- Add your image here
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Mark Adam",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Sunny_Koelpin45@hotmail.com",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Pressable menu items
              buildMenuItem(Icons.person, "Profile", () {
                // TODO: Navigate or handle action
                print("Profile tapped");
              }),
              buildMenuItem(Icons.settings, "Setting", () {
                print("Setting tapped");
              }),
              buildMenuItem(Icons.mail, "Contact", () {
                print("Contact tapped");
              }),
              buildMenuItem(Icons.share, "Share App", () {
                print("Share App tapped");
              }),
              buildMenuItem(Icons.help_outline, "Help", () {
                print("Help tapped");
              }),

              const SizedBox(height: 30),

              // Sign Out
              Center(
                child: TextButton(
                  onPressed: () {
                    print("Sign Out tapped");
                  },
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          backgroundColor: const Color(0xFFF5F5F5),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
