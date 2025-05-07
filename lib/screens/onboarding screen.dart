import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'landing.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  void completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) =>LandingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => isLastPage = index == 2);
                },
                children: const [
                  OnboardPage(title: "Welcome to GoComplaint", desc: "Easily report your concerns to GOIL."),
                  OnboardPage(title: "Track Complaints", desc: "Know when your issue is resolved."),
                  OnboardPage(title: "Direct Access", desc: "Reach the right department with ease."),
                ],
              ),
            ),
            SmoothPageIndicator(controller: _controller, count: 3),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: completeOnboarding,
              child: Text(isLastPage ? "Get Started" : "Next"),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardPage extends StatelessWidget {
  final String title, desc;
  const OnboardPage({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
