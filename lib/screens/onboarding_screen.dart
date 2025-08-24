import 'package:flutter/material.dart';
import 'package:laptopharbor/constants.dart';
import 'package:laptopharbor/screens/login_screen.dart';
import 'package:laptopharbor/screens/signup_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background circles
          Positioned(
            top: -310,
            right: -310,
            child: Container(
              height: 610,
              width: 610,
              decoration: BoxDecoration(
                color: lightblue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -((1 / 4) * 480),
            right: -((1 / 4) * 480),
            child: Container(
              height: 450,
              width: 450,
              decoration: BoxDecoration(
                border: Border.all(color: lightblue, width: 2),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Lottie.asset('assets/Onboarding.json'),
              ),
              const SizedBox(height: 40),
              Text(
                "Welcome To Laptop Harbor",
                style: h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 11),
              Text(
                "Buy Best Quality Laptops Today, Order Now!",
                style: body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Login + Signup buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 160,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const LoginScreen()),
);

                      },
                      child: Text(
                        "Login",
                        style: h2.copyWith(color: white, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  SizedBox(
                    height: 60,
                    width: 160,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                         Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const SignupScreen()),
);
                      },
                      child: Text(
                        "Signup",
                        style: h2.copyWith(color: black, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          //  Google button 
          Positioned(
            bottom: 150,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
                label: Text(
                  "Continue with Google",
                  style: h2.copyWith(color: black, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
