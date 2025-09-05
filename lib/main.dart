import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:laptopharbor/screens/onboarding_screen.dart';
import 'package:laptopharbor/theme_provider.dart';
import 'package:laptopharbor/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Laptop Harbor",

      // 🌞 Light Theme
      theme: ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: white,
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: black),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: lightblue,
          labelStyle: TextStyle(color: black),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: white,
          selectedItemColor: primary,
          unselectedItemColor: Colors.grey,
        ),
      ),

      // 🌙 Dark Theme
      darkTheme: ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xFF1E1E1E),
          labelStyle: TextStyle(color: white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: primary,
          unselectedItemColor: Colors.grey,
        ),
      ),

      themeMode: themeProvider.currentTheme, // 🔥 controlled by Provider
      home: const OnboardingScreen(),
    );
  }
}
