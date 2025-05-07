import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gocomplaints/screens/landing.dart';
import 'package:gocomplaints/screens/onboarding%20screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('seenOnboarding') ?? false;
  runApp(MyApp(showOnboarding: showOnboarding));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  const MyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'GoComplaint',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: showOnboarding ? LandingPage() : const OnboardingScreen(),
    );
  }
}
