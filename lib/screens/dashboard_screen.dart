import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:laptopharbor/constants.dart';
import 'package:laptopharbor/screens/cart_page.dart';
import 'package:laptopharbor/screens/home_page.dart';
import 'package:laptopharbor/screens/laptops_page.dart';
import 'package:laptopharbor/screens/login_screen.dart';
import 'package:laptopharbor/screens/profile_page.dart';
import 'package:laptopharbor/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentTheme == ThemeMode.dark;

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
              icon: const Icon(Icons.logout, color: white),
            ),
            const SizedBox(width: 10),
            const Text(
              "Laptop Harbor",
              style: TextStyle(color: white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => _currentIndex = 3), // Profile tab
            icon: const Icon(Icons.person, color: white),
          ),
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme(); // 🔥 Global toggle
            },
            icon: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: white,
            ),
          ),
        ],
      ),

      // ✅ Pass darkMode only if widget needs it
      body: _currentIndex == 0
          ? HomePage(isDarkMode: isDarkMode)
          : _currentIndex == 1
              ? const LaptopsPage()
              : _currentIndex == 2
                  ? const CartPage()
                  : const ProfilePage(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          // Add action (upload/add laptop)
        },
        child: const Icon(Icons.add, color: white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: isDarkMode ? Colors.black : Colors.white, // 🔥 Dark mode applied
        activeColor: primary,
        inactiveColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
