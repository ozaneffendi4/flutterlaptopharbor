import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:laptopharbor/constants.dart';
import 'package:laptopharbor/screens/cart_page.dart';
import 'package:laptopharbor/screens/home_page.dart';
import 'package:laptopharbor/screens/laptops_page.dart';
import 'package:laptopharbor/screens/profile_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final iconList = <IconData>[
    Icons.home,        // Home
    Icons.laptop,      // Laptop
    Icons.shopping_cart, // Cart
    Icons.person       // Profile
  ];

  final pages = const [
  HomePage(),
  LaptopsPage(),
  CartPage(),
  ProfilePage(),
];

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  automaticallyImplyLeading: false, // ⬅️ removes back button
  title: const Text(
    "Laptop Harbor",
    style: TextStyle(color: white, fontWeight: FontWeight.bold),
  ),
  backgroundColor: primary,
  centerTitle: true,
),

      body: pages[_currentIndex],

      // Floating Add Button in Middle
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          // Add action (open upload/add laptop etc.)
        },
        child: const Icon(Icons.add, color: white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Animated Bottom Navigation
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center, // space for FAB
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: Colors.white,
        activeColor: primary,
        inactiveColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
