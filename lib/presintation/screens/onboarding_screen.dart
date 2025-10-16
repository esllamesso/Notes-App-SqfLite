import 'package:flutter/material.dart';
import 'package:test_pr/presintation/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.08,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/onboarding.png",
                    fit: BoxFit.contain,
                    height: height * 0.6,
                    width: width * 0.8,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.05),
            Container(
              width: width * 0.25,
              height: height * 0.015,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            SizedBox(height: height * 0.10),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                height: height * 0.07,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    "To Notes",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
