import 'package:egalee_admin/screens/books_screen/view/book_category_screen.dart';
import 'package:egalee_admin/screens/ilts_screen/view.dart';
import 'package:egalee_admin/screens/login_screen.dart';
import 'package:egalee_admin/screens/common_data_screen/slider_image_upload_screen.dart';
import 'package:egalee_admin/screens/common_data_screen/update_contact_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../hsc_admission_screen/hsc_admission_screen.dart';
import '../job_circular_screen/all_category_screen.dart';
import '../job_preparation_screen/job_preparation_screen.dart';
import '../skill_career_screen/view.dart';

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
              title: 'Job Preparation',
              icon: Icons.extension_sharp,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => JobPreparationScreen(),
                  ),
                );
              },
            ),        HomeOptionCard(
              title: 'Books',
              icon: Icons.menu_book_rounded,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => BooksCategoriesScreen(),
                  ),
                );
              },
            ),
            HomeOptionCard(
              title: 'Hsc & University Preparation',
              icon: Icons.school_outlined,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => HscAndUniversityPrep(),
                  ),
                );
              },
            ),
       
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
            HomeOptionCard(
              title: 'IELTS Preparation',
              icon: Icons.language,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => ModuleScreen(),
                  ),
                );
              },
            ),
    
            HomeOptionCard(
              title: 'Skills and Career',
              icon: Icons.stacked_line_chart_rounded,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        SkillCareerModuleScreen(),
                  ),
                );
              },
            ),
            HomeOptionCard(
              title: 'Slider images',
              icon: Icons.image_outlined,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => SliderScreen(),
                  ),
                );
              },
            ),
            HomeOptionCard(
              title: 'Support info',
              icon: Icons.support_agent,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        SupportInfoUpdateScreen(),
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
