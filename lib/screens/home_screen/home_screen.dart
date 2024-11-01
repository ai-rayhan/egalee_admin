import 'package:egalee_admin/screens/books_screen/view/book_category_screen.dart';
import 'package:egalee_admin/screens/course_unlock_request_screen/books_buy_request_screen.dart';
import 'package:egalee_admin/screens/course_unlock_request_screen/course_unlock_request_screen.dart';
import 'package:egalee_admin/screens/ilts_screen/view.dart';
import 'package:egalee_admin/screens/login_screen.dart';
import 'package:egalee_admin/screens/common_data_screen/slider_image_upload_screen.dart';
import 'package:egalee_admin/screens/common_data_screen/update_contact_info.dart';
import 'package:egalee_admin/screens/notifications/view.dart';
import 'package:egalee_admin/screens/payment_details/payment_details.dart';
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
        title: const Text('Control Panel'),
        actions: [IconButton(onPressed: _logout, icon: const Icon(Icons.logout))],
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
                    builder: (BuildContext context) => const JobPreparationScreen(),
                  ),
                );
              },
            ),        HomeOptionCard(
              title: 'Book Shop',
              icon: Icons.menu_book_rounded,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const BooksCategoriesScreen(),
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
                    builder: (BuildContext context) => const HscAndUniversityPrep(),
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
                    builder: (BuildContext context) => const JobCategoryScreen(),
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
              title: 'Course Unlock Request',
              icon: Icons.lock_open_outlined,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const RequestAcceptScreen(),
                  ),
                );
              },
            ),
               HomeOptionCard(
              title: 'Book Buy Request',
              icon: Icons.menu_book_rounded,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const BookBuyRequestScreen(),
                  ),
                );
              },
            ),
            HomeOptionCard(
              title: 'Notifications',
              icon: Icons.notification_add,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>  NotificationScreen(),
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
                    builder: (BuildContext context) => const SliderScreen(),
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
            HomeOptionCard(
              title: 'Payment info',
              icon: Icons.payment,
              ontap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const PaymentDetailsScreen(),
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

  const HomeOptionCard(
      {super.key, required this.title, required this.icon, required this.ontap});

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
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          onTap: ontap),
    );
  }
}
