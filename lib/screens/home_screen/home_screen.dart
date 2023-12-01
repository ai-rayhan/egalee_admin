

import 'package:egalee_admin/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../job_circular_screen/all_category_screen.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // context.read<DataProvider>().fetchAdminData();
    super.initState();
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      // Navigate to the login page or any other screen you want after logout.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => LoginPage(),
        ),
      );
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Panel'),
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeOptionCard(
              title: 'Job Circular',
              icon: Icons.work,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => JobCategoryScreen(),
                  ),
                );
              },
            ),
            
          ],
        ),
      ),
    );
  }
}

class HomeOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback ontap;

  HomeOptionCard(
      {required this.title, required this.icon, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
          leading: Icon(
            icon,
            size: 48.0,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          onTap: ontap),
    );
  }
}
