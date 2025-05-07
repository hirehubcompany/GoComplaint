import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RepDashboardProfile extends StatefulWidget {
  const RepDashboardProfile({super.key});

  @override
  State<RepDashboardProfile> createState() => _RepDashboardProfileState();
}

class _RepDashboardProfileState extends State<RepDashboardProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: ListView(
        children: [
          ElevatedButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
              },
              child: Text('Log Out')
          )
        ],

      ),
    );
  }
}
