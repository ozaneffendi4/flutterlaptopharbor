import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laptopharbor/screens/cart_screen.dart';
import 'package:laptopharbor/screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final picker = ImagePicker();

  User? user = FirebaseAuth.instance.currentUser;

  bool isEditingName = false;
  bool isEditingPhone = false;

  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: user?.displayName ?? "");
    phoneController = TextEditingController(text: user?.phoneNumber ?? "");
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      // TODO: Upload the image to Firebase Storage and save URL to user profile if needed
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Picture
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : (user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : const AssetImage("assets/images/default_user.png")
                              as ImageProvider),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _pickImage,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Name Field
          Row(
            children: [
              Expanded(
                child: isEditingName
                    ? TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            isEditingName = false;
                          });
                          // Optionally update Firebase Auth displayName
                          user?.updateDisplayName(value);
                        },
                      )
                    : Text(
                        "Name: ${user?.displayName ?? 'No Name'}",
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
              IconButton(
                icon: Icon(isEditingName ? Icons.check : Icons.edit),
                onPressed: () {
                  setState(() {
                    if (isEditingName) {
                      user?.updateDisplayName(nameController.text);
                    }
                    isEditingName = !isEditingName;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Email (read-only)
          Text(
            "Email: ${user?.email ?? 'No Email'}",
            style: const TextStyle(fontSize: 18),
          ),
          const Divider(height: 30),

          // Phone Field
          Row(
            children: [
              Expanded(
                child: isEditingPhone
                    ? TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Phone",
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            isEditingPhone = false;
                          });
                        },
                      )
                    : Text(
                        "Phone: ${user?.phoneNumber ?? 'Not set'}",
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
              IconButton(
                icon: Icon(isEditingPhone ? Icons.check : Icons.edit),
                onPressed: () {
                  setState(() {
                    isEditingPhone = !isEditingPhone;
                  });
                },
              ),
            ],
          ),
          const Divider(height: 30),

          // My Orders
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text("My Orders"),
            onTap: () {
              final uid = user?.uid;
              if (uid != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartPage(userId: uid)),
                );
              }
            },
          ),
          const Divider(),

          // Logout Button
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(150, 50),
              ),
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }
}
