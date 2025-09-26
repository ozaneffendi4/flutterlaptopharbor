import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:laptopharbor/constants.dart';
import 'package:laptopharbor/admin/admin_dashboard.dart';
import 'package:laptopharbor/screens/signup_screen.dart';
import 'package:laptopharbor/screens/dashboard_screen.dart';
import 'package:laptopharbor/screens/forgot_password_screen.dart';
import 'package:laptopharbor/theme_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoading = false;

  // ✅ Login Function
  Future<void> _login() async {
    setState(() => isLoading = true);

    try {
      // --- Firebase Login ---
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final user = userCredential.user;
      if (user == null) throw Exception("User not found");

      // --- Fetch user role from Firestore ---
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (!snapshot.exists)
        throw Exception("User record not found in Firestore");

      final userData = snapshot.data()!;
      final role = userData['role'] ?? 'user'; // default to 'user'

      // --- Redirect based on role ---
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }

      print("✅ Logged in as ${user.email} with role: $role");
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = "No account found with this email.";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password. Try again.";
      } else {
        message = "Login failed: ${e.message}";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      print("❌ Unexpected Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          // ===== Background Circles =====
          Positioned(
            top: -310,
            right: -310,
            child: Container(
              height: 610,
              width: 610,
              decoration: BoxDecoration(
                color:  themeProvider.isDarkMode ? const Color.fromARGB(99, 16, 45, 150) : primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -120,
            child: Container(
              height: 450,
              width: 450,
              decoration: BoxDecoration(
                border: Border.all(color: lightblue, width: 2),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // ===== Page Content =====
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    SizedBox(height: 70),
                    Text("Welcome Back", style: h1.copyWith(fontSize: 32)),
                    const SizedBox(height: 5),
                    Text(
                      "Login to your account",
                      style: body.copyWith(color: Colors.grey[700]),
                    ),

                    const SizedBox(height: 40),

                    // Email Field
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: isLoading ? null : _login,
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  "Login",
                                  style: h2.copyWith(
                                    color: white,
                                    fontSize: 20,
                                  ),
                                ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // OR Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("OR", style: body),
                        ),
                        const Expanded(child: Divider(thickness: 1)),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Google Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.black12),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Google Sign-In not implemented yet",
                              ),
                            ),
                          );
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.red,
                        ),
                        label: Text(
                          "Continue with Google",
                          style: h2.copyWith(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Signup & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don’t have an account?", style: body),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignupScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: body.copyWith(color: primary),
                          ),
                        ),
                      ],
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: body.copyWith(color: primary),
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
