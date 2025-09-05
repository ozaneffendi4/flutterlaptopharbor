import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:laptopharbor/screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final picker = ImagePicker();

  String name = "John Doe";
  String phone = "+92 300 1234567";

  bool isEditingName = false;
  bool isEditingPhone = false;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
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
                      : const AssetImage("assets/images/default_user.png")
                          as ImageProvider,
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
          const SizedBox(height: 30),

          // Name Field
          Row(
            children: [
              Expanded(
                child: isEditingName
                    ? TextField(
                        controller: nameController..text = name,
                        onSubmitted: (value) {
                          setState(() {
                            name = value;
                            isEditingName = false;
                          });
                        },
                      )
                    : Text(
                        "Name: $name",
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
              IconButton(
                icon: Icon(isEditingName ? Icons.check : Icons.edit),
                onPressed: () {
                  if (isEditingName) {
                    setState(() {
                      name = nameController.text;
                      isEditingName = false;
                    });
                  } else {
                    setState(() {
                      isEditingName = true;
                    });
                  }
                },
              ),
            ],
          ),
          const Divider(),

          // Phone Field
          Row(
            children: [
              Expanded(
                child: isEditingPhone
                    ? TextField(
                        controller: phoneController..text = phone,
                        keyboardType: TextInputType.phone,
                        onSubmitted: (value) {
                          setState(() {
                            phone = value;
                            isEditingPhone = false;
                          });
                        },
                      )
                    : Text(
                        "Phone: $phone",
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
              IconButton(
                icon: Icon(isEditingPhone ? Icons.check : Icons.edit),
                onPressed: () {
                  if (isEditingPhone) {
                    setState(() {
                      phone = phoneController.text;
                      isEditingPhone = false;
                    });
                  } else {
                    setState(() {
                      isEditingPhone = true;
                    });
                  }
                },
              ),
            ],
          ),
          const Divider(),

          // Orders
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text("My Orders"),
            onTap: () {
              // TODO: Navigate to Orders Page
            },
          ),
          const Divider(),

          // Order Tracking
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: const Text("Track Orders"),
            onTap: () {
              // TODO: Navigate to Tracking Page
            },
          ),
          const Divider(),

          // Logout Button
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                LoginScreen();
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }
}
