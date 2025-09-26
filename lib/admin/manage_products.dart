import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  File? _imageFile;
  double _stars = 0;
  bool _isSaving = false;
  DocumentSnapshot? _editingProduct;

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Convert image to Base64
  String? _imageToBase64() {
    if (_imageFile == null) return null;
    final bytes = _imageFile!.readAsBytesSync();
    return base64Encode(bytes);
  }

  // Convert Base64 to Image widget
  Image _base64ToImage(String base64String) {
    final bytes = base64Decode(base64String);
    return Image.memory(bytes, fit: BoxFit.cover);
  }

  // Save product (add or edit)
  Future<void> _saveProduct() async {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Fill all fields")));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final data = {
        "title": _titleController.text.trim(),
        "description": _descController.text.trim(),
        "price": double.tryParse(_priceController.text.trim()) ?? 0,
        "quantity": int.tryParse(_quantityController.text.trim()) ?? 1,
        "review": _stars,
        "imageBase64":
            _imageToBase64() ?? (_editingProduct?["imageBase64"] ?? ""),
        "createdAt": FieldValue.serverTimestamp(),
      };

      if (_editingProduct == null) {
        await _firestore.collection("products").add(data);
      } else {
        await _firestore
            .collection("products")
            .doc(_editingProduct!.id)
            .update(data);
      }

      _clearForm();
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Product saved!")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error saving product: $e")));
      print("Error is ==> $e");
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descController.clear();
    _priceController.clear();
    _quantityController.clear();
    _imageFile = null;
    _stars = 0;
    _editingProduct = null;
  }

  void _editProduct(DocumentSnapshot product) {
    _editingProduct = product;
    _titleController.text = product["title"];
    _descController.text = product["description"];
    _priceController.text = product["price"].toString();
    _quantityController.text = product["quantity"].toString();
    _stars = product["review"]?.toDouble() ?? 0;
    _imageFile = null;
    _showBottomSheet();
  }

  Future<void> _deleteProduct(String id) async {
    await _firestore.collection("products").doc(id).delete();
  }

  // ---- Updated bottom sheet with StatefulBuilder ----
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        _editingProduct == null
                            ? "Add Product"
                            : "Edit Product",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                            labelText: "Title",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _descController,
                        maxLines: 3,
                        decoration: InputDecoration(
                            labelText: "Description",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Price",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Quantity",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("Review: ", style: TextStyle(fontSize: 16)),
                          for (int i = 1; i <= 5; i++)
                            IconButton(
                              icon: Icon(
                                  _stars >= i
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber),
                              onPressed: () {
                                setState(() => _stars = i.toDouble());
                                setModalState(() {}); // refresh sheet stars
                              },
                            )
                        ],
                      ),
                      const SizedBox(height: 10),

                      // --- Image Picker with live refresh ---
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() => _imageFile = File(pickedFile.path));
                            setModalState(() {}); // refresh the sheet UI
                          }
                        },
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15)),
                          child: _imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(_imageFile!,
                                      fit: BoxFit.cover))
                              : (_editingProduct != null &&
                                      _editingProduct!["imageBase64"] != null &&
                                      _editingProduct!["imageBase64"] != ""
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: _base64ToImage(
                                          _editingProduct!["imageBase64"]),
                                    )
                                  : const Icon(Icons.add_a_photo,
                                      size: 50, color: Colors.grey)),
                        ),
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: _isSaving ? null : _saveProduct,
                        child: _isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("Save"),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("products")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return const Center(
              child: Text(
                "No products yet.\nClick + to add one.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: products.map((doc) {
                final product = doc.data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: product["imageBase64"] != null &&
                            product["imageBase64"] != ""
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _base64ToImage(product["imageBase64"]),
                          )
                        : const Icon(Icons.image),
                    title: Text(product["title"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "\$${product["price"]} | Qty: ${product["quantity"]}"),
                          Row(
                            children: List.generate(
                                5,
                                (i) => Icon(
                                      i < (product["review"] ?? 0)
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 16,
                                      color: Colors.amber,
                                    )),
                          ),
                        ]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editProduct(doc),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(doc.id),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _editingProduct = null;
          _clearForm();
          _showBottomSheet();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
