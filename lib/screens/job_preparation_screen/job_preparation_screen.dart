import 'package:egalee_admin/screens/job_preparation_screen/common_screen/view/all_subject_screen.dart';
import 'package:egalee_admin/screens/job_preparation_screen/live_exam_screen/live_exam_screen.dart';
import 'package:flutter/material.dart';



class JobPreparationScreen extends StatelessWidget {
  const JobPreparationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Preparation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                modules[index].route),
                      );
                    },
                    title: Text(modules[index].moduleName)),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: modules.length)
          ],
        ),
      ),
    );
  }
}

class Module {
  const Module({
    Key? key,
    required this.moduleName,
    required this.route,
  });

  final String moduleName;

  final Widget route;
}

List<Module> modules = [
  const Module(
      moduleName: "Free Course",
      route: AllSubjectScreen(groupName: 'Free course')),
  const Module(
      moduleName: "Job Solution",
      route: AllSubjectScreen(groupName: 'Job Solution')),
  const Module(
      moduleName: "BCS Preparation",
      route: AllSubjectScreen(groupName: 'BCS Preparation')),
  const Module(
      moduleName: "Bank Job Preparation",
      route: AllSubjectScreen(groupName: 'Bank Job Preparation')),
  const Module(
      moduleName: "NTRCA & Primary Preparation",
      route: AllSubjectScreen(groupName: 'NTRCA & Primary Preparation')),
  const Module(
      moduleName: "Recent Job Solution",
      route: AllSubjectScreen(groupName: 'Recent Job Solution')),
  const Module(
      moduleName: "Written Preparation",
      route: AllSubjectScreen(groupName: 'Written Preparation')),
  const Module(
      moduleName: "Viva Preparation",
      route: AllSubjectScreen(groupName: 'Viva Preparation')),

  const Module(
      moduleName: "Video section",
      route: AllSubjectScreen(groupName: 'Video section')),
  const Module(
      moduleName: "PDF section",
      route: AllSubjectScreen(groupName: 'PDF section')),
  const Module(
      moduleName: "Live Exam",
      route: LiveExamSubjectScreen(groupName: 'Live Exam')),
];
