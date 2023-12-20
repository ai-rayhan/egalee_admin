import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home_screen/home_screen.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String _email = "";
  String _password = "";
  bool _isLoading = false;

  Future<String?> getUserRole(String userId) async {
    String? role;

    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        role = userDoc.data()?['role'];
      }
    } catch (e) {
      print("Error getting user role: $e");
    }

    return role;
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        final userId = userCredential.user!.uid;
        final userRole = await getUserRole(userId);

        if (userRole == 'admin') {
          // User is an admin
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(), // Admin-specific page
            ),
          );
        } else {
          // User is not an admin, redirect to a regular user page
         showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Access Denied"),
              content: const Text("You do not have admin privileges."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
        }

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        // Handle login errors
        print("Error: $e");
        setState(() {
          _isLoading = false;
        });

        // Show an alert dialog with the error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Login Error"),
              content: Text("There was an error during login: $e"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Egalee Admin'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password is too short';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        child: const Text('Login'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
