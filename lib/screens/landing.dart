import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gocomplaints/screens/homepage/admin/homepage.dart';
import 'package:gocomplaints/screens/homepage/complaintant/homepage.dart';
import 'package:gocomplaints/screens/homepage/rep%20dashboard/homepage.dart';

import 'login.dart';


class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong while initializing Firebase.')),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return const Scaffold(
                  body: Center(child: Text('Something went wrong with auth stream.')),
                );
              }

              if (streamSnapshot.connectionState == ConnectionState.active) {
                final User? user = streamSnapshot.data;

                if (user == null) {
                  return const LoginPage();
                } else {
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                        return const Scaffold(
                          body: Center(child: Text('User data not found.')),
                        );
                      }

                      final role = userSnapshot.data!['role'];

                      if (role == 'admin') {
                        return const Admin();
                      } else if (role == 'rep') {
                        return const RepDashboard();
                      } else if (role == 'complainant') {
                        return const ComplainantDashboard();
                      } else {
                        return const Scaffold(
                          body: Center(child: Text('Invalid role.')),
                        );
                      }
                    },
                  );
                }
              }

              return const Scaffold(
                body: Center(child: Text('Checking authentication...')),
              );
            },
          );
        }

        return const Scaffold(
          body: Center(child: Text('Loading Firebase...')),
        );
      },
    );
  }
}
