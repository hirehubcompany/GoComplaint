import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../widgets/constant.dart';
import '../widgets/custom btn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _registerFormLoading = false;
  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  String _selectedRole = 'complainant';
  bool _isPasswordVisible = false;

  final List<String> _roles = ['complainant', 'rep'];

  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<String?> _registerUser() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _email,
        'firstName': _firstName,
        'lastName': _lastName,
        'role': _selectedRole,
        'isApproved': _selectedRole == 'rep' ? false : true,
        'createdAt': Timestamp.now(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    setState(() => _registerFormLoading = true);

    String? feedback = await _registerUser();
    if (feedback != null) {
      await _showErrorDialog(feedback);
    } else {
      Navigator.pop(context); // Go back to login after successful registration
    }

    setState(() => _registerFormLoading = false);
  }

  Widget _buildTextField(String label, IconData icon, Function(String) onChanged,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: TextField(
        obscureText: isPassword && !_isPasswordVisible,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(_isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedRole,
        decoration: InputDecoration(
          labelText: 'Select Role',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        items: _roles
            .map((role) => DropdownMenuItem(value: role, child: Text(role)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedRole = value!;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
              radius: 50,
            ),
            const SizedBox(height: 16),
            Text('Create a GoComplaint Account',
                textAlign: TextAlign.center, style: Constants.boldHeading),
            const SizedBox(height: 8),
            Text('Fill in the details below',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
            const SizedBox(height: 32),

            _buildTextField('First Name', Icons.person, (value) => _firstName = value),
            _buildTextField('Last Name', Icons.person, (value) => _lastName = value),
            _buildTextField('Email', Icons.email, (value) => _email = value),
            _buildTextField('Password', Icons.lock, (value) => _password = value, isPassword: true),
            _buildRoleDropdown(),
            const SizedBox(height: 24),

            GestureDetector(
              onTap: _submitForm,
              child: CustomBtn(
                text: 'Create Account',
                outlineBtn: false,
                isLoading: _registerFormLoading,
              ),
            ),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CustomBtn(
                  text: 'Back to Login',
                  outlineBtn: true,
                  isLoading: false,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
