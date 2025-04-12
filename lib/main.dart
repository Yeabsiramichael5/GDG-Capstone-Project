import 'package:flutter/material.dart';
import 'profile_page.dart'; // Import the ProfilePage file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const ProfilePage(), 
    );
  }
}
