import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ComplainantProfileHomepage extends StatefulWidget {
  const ComplainantProfileHomepage({super.key});

  @override
  State<ComplainantProfileHomepage> createState() => _ComplainantProfileHomepageState();
}

class _ComplainantProfileHomepageState extends State<ComplainantProfileHomepage> {
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
