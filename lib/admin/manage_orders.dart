import 'package:flutter/material.dart';

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Order #1001"),
            subtitle: Text("Status: Pending"),
            trailing: Icon(Icons.track_changes),
          ),
        ],
      ),
    );
  }
}
