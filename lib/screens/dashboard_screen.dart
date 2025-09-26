import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:laptopharbor/constants.dart';
import 'package:laptopharbor/screens/cart_screen.dart';
import 'package:laptopharbor/screens/home_page.dart';
import 'package:laptopharbor/screens/laptops_page.dart';
import 'package:laptopharbor/screens/login_screen.dart';
import 'package:laptopharbor/screens/profile_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final iconList = <IconData>[
    Icons.home,          // Home
    Icons.laptop,        // Laptop
    Icons.shopping_cart, // Cart
    Icons.person,        // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              "Laptop Harbor",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: _currentIndex == 0
          ? HomePage()
          : _currentIndex == 1
              ? const LaptopsPage()
              : _currentIndex == 2
                  ? const CartPage(userId: '') // pass current user ID
                  : const ProfilePage(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          // Add laptop upload functionality for admin
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: Colors.white,
        activeColor: primary,
        inactiveColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
