import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> favoriteItems = [
      "Nike Tech",
      "Addidas Samba",
      "Under Armour",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text(favoriteItems[index]),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
              onPressed: () {
                // Handle removal
              },
            ),
          );
        },
      ),
    );
  }
}
