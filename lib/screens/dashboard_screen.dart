import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:laptopharbor/constants.dart';
import 'package:laptopharbor/screens/cart_screen.dart';
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
    Icons.home,
    Icons.book,
    Icons.shopping_cart,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              "Laptop Harbor",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => themeProvider.toggleTheme(),
              icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
            ),
          ],
        ),
      ),
      body: _currentIndex == 0
          ? const HomePage()
          : _currentIndex == 1
              ? const LaptopsPage()
              : _currentIndex == 2
                  ? (uid != null
                      ? CartPage(userId: uid)
                      : const Center(child: Text("Please login to view your cart")))
                  : const ProfilePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Admin add laptop
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        activeColor: primary,
        inactiveColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
