import 'package:flutter/material.dart';
import 'package:gocomplaints/screens/homepage/complaintant/profile/homepage.dart';

import 'my complaints/complaint form/homepage.dart';



class ComplainantDashboard extends StatefulWidget {
  const ComplainantDashboard({super.key});

  @override
  State<ComplainantDashboard> createState() => _ComplainantDashboardState();
}

class _ComplainantDashboardState extends State<ComplainantDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ComplaintsPage(), //Center(child: Text("Homeee", style: TextStyle(fontSize: 22))),
    Center(child: Text("My Complaints", style: TextStyle(fontSize: 22))),
    Center(child: Text("Notifications", style: TextStyle(fontSize: 22))),
    ComplainantProfileHomepage()
  ];

  final List<String> _titles = [
    "Home",
    "My Complaints",
    "Notifications",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Complaints',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
