import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

import 'package:gocomplaints/screens/pending approval.dart';
import 'package:gocomplaints/screens/registration.dart';

import '../widgets/constant.dart';
import '../widgets/custom btn.dart';
import '../widgets/custom input.dart';
import 'homepage/complaintant/homepage.dart';
import 'homepage/rep dashboard/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _loginEmail = '';
  String _loginPassword = '';
  bool _loginFormLoading = false;

  late FocusNode _passwordFocusNode;
  late FocusNode _emailFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _showErrorDialog(String error) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    setState(() => _loginFormLoading = true);
    try {
      final auth = FirebaseAuth.instance;
      final userCredential = await auth.signInWithEmailAndPassword(
        email: _loginEmail.trim(),
        password: _loginPassword,
      );

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      final data = userDoc.data();
      if (data == null) throw Exception("User data not found");

      final role = data['role'];
      final isApproved = data['isApproved'] ?? false;

      if (role == 'rep' && !isApproved) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PendingApprovalScreen()),
        );
      } else if (role == 'rep') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RepDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ComplainantDashboard()),
        );
      }
    } on FirebaseAuthException catch (e) {
      await _showErrorDialog(e.message ?? 'Something went wrong');
    } catch (e) {
      await _showErrorDialog(e.toString());
    } finally {
      setState(() => _loginFormLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('GoComplaint', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text('Login to GoComplaint', style: Constants.boldHeading),
                  const SizedBox(height: 24),

                  CustomInput(
                    hintText: 'Email',
                    onChanged: (value) => _loginEmail = value,
                    textInputAction: TextInputAction.next,
                    isPasswordField: false,
                    focusNode: _emailFocusNode,
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                  ),
                  CustomInput(
                    hintText: 'Password',
                    onChanged: (value) => _loginPassword = value,
                    isPasswordField: true,
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submitForm(),
                  ),
                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: _submitForm,
                    child: CustomBtn(
                      text: 'Login',
                      isLoading: _loginFormLoading,
                      outlineBtn: false,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterPage()),
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
