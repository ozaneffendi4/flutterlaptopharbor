import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptopharbor/constants.dart';
import 'package:laptopharbor/screens/cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  String searchQuery = '';
  String sortOrder = 'none'; // 'low' or 'high'

  Image _base64ToImage(String base64String) {
    final bytes = base64Decode(base64String);
    return Image.memory(bytes, fit: BoxFit.cover);
  }

  void _addToCartPopup(Map<String, dynamic> product) {
    final TextEditingController qtyController = TextEditingController(text: "1");
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 20),
              const Text("Order Product", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Text(product["title"] ?? "Product", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Full Address",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () async {
                  final qty = int.tryParse(qtyController.text.trim()) ?? 1;
                  final name = nameController.text.trim();
                  final phone = phoneController.text.trim();
                  final address = addressController.text.trim();

                  if (qty <= 0 || name.isEmpty || phone.isEmpty || address.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields correctly")),
                    );
                    return;
                  }

                  if (userId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("User not logged in")),
                    );
                    return;
                  }

                  await _firestore.collection("orders").add({
                    "userId": userId,
                    "productId": product["id"],
                    "productTitle": product["title"],
                    "quantity": qty,
                    "name": name,
                    "phone": phone,
                    "address": address,
                    "status": "pending",
                    "createdAt": FieldValue.serverTimestamp(),
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order placed! Pending approval.")),
                  );
                },
                child: const Text("Place Order"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Build the search bar + filter dropdown
  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: sortOrder,
            items: const [
              DropdownMenuItem(value: 'none', child: Text("Sort")),
              DropdownMenuItem(value: 'low', child: Text("Price ↑")),
              DropdownMenuItem(value: 'high', child: Text("Price ↓")),
            ],
            onChanged: (value) {
              setState(() {
                sortOrder = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Banner image
          Container(
            margin: const EdgeInsets.all(16),
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage("assets/laptop_banner.png"), // <-- replace with your banner
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Search + Filter
          _buildSearchAndFilter(),

          // Products
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("products").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text("Something went wrong"));
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                var products = snapshot.data!.docs
                    .map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      data["id"] = doc.id;
                      return data;
                    })
                    .where((p) => p["title"].toString().toLowerCase().contains(searchQuery))
                    .toList();

                if (sortOrder == 'low') {
                  products.sort((a, b) => (a["price"] ?? 0).compareTo(b["price"] ?? 0));
                } else if (sortOrder == 'high') {
                  products.sort((a, b) => (b["price"] ?? 0).compareTo(a["price"] ?? 0));
                }

                if (products.isEmpty) return const Center(child: Text("No products found."));

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return GestureDetector(
                      onTap: () => _addToCartPopup(product),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: product["imageBase64"] != null && product["imageBase64"].toString().isNotEmpty
                                    ? _base64ToImage(product["imageBase64"])
                                    : const Icon(Icons.laptop, size: 50, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(product["title"] ?? "No title", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            const SizedBox(height: 5),
                            Text("\$${product["price"] ?? 0}", style: const TextStyle(color: primary, fontSize: 16)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
