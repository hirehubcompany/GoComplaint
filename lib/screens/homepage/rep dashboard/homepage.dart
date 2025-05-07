import 'package:flutter/material.dart';
import 'package:gocomplaints/screens/homepage/rep%20dashboard/profile/homepage.dart';

class RepDashboard extends StatefulWidget {
  const RepDashboard({super.key});

  @override
  State<RepDashboard> createState() => _RepDashboardState();
}

class _RepDashboardState extends State<RepDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Dashboard Overview", style: TextStyle(fontSize: 22))),
    Center(child: Text("Assigned Complaints", style: TextStyle(fontSize: 22))),
    Center(child: Text("Notifications", style: TextStyle(fontSize: 22))),
    RepDashboardProfile()
  ];

  final List<String> _titles = [
    "Dashboard",
    "Complaints",
    "Alerts",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in_outlined),
            label: 'Complaints',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
