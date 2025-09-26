import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LaptopsPage extends StatefulWidget {
  const LaptopsPage({super.key});

  @override
  State<LaptopsPage> createState() => _LaptopsPageState();
}

class _LaptopsPageState extends State<LaptopsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLaptopCard(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.blue.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(description,
                  style: GoogleFonts.roboto(fontSize: 14),
                  textAlign: TextAlign.justify),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
       
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Discover Our Laptop Collection",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildLaptopCard(
                    "High Performance Laptop",
                    "Blazing fast speed and top efficiency. Perfect for work, gaming, and creative tasks. Equipped with latest processors and high-end graphics for ultimate performance.",
                  ),
                  _buildLaptopCard(
                    "Ultra-Slim Laptop",
                    "Portable and stylish. Slim, lightweight design makes it ideal for students and professionals on the move.",
                  ),
                  _buildLaptopCard(
                    "Gaming Beast Laptop",
                    "Dominate games with cutting-edge hardware, high-refresh displays, and immersive graphics. Built for gamers who demand the best.",
                  ),
                  _buildLaptopCard(
                    "Business Professional Laptop",
                    "Reliable and secure for all your business needs. Long battery life, sleek design, and enterprise-level performance to stay productive.",
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
