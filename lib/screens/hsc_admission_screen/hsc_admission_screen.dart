import 'package:flutter/material.dart';

import 'du_admission_screen/du_admission_screen.dart';
import 'hsc_prep_screen/hsc_prep_screen.dart';
import 'common_screen/view/all_subject_screen.dart';
import 'live_exam_screen/live_exam_screen.dart';

class HscAndUniversityPrep extends StatelessWidget {
  const HscAndUniversityPrep({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HSC & Admission'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
                separatorBuilder: (context, index) => Divider(),
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
  Module(
      moduleName: "HSC Preparation",
      route: HscprepScreen(screenName: 'HSC Preparation')),
  Module(
      moduleName: "Admission Question Bank",
      route: AllSubjectScreen(groupName: 'Admission Question Bank')),
  Module(
      moduleName: "DU Admission",
      route: DUAdmissionScreen(screenName: 'DU Admission')),
  Module(
      moduleName: "GST Admission",
      route: AllSubjectScreen(groupName: 'GST Admission')),
  Module(
      moduleName: "Written Preparation",
      route: AllSubjectScreen(groupName: 'Written Preparation')),
  Module(
      moduleName: "Medical Admission",
      route: AllSubjectScreen(groupName: 'Medical Admission')),

  Module(
      moduleName: "Video section",
      route: AllSubjectScreen(groupName: 'Video section')),
  Module(
      moduleName: "PDF section",
      route: AllSubjectScreen(groupName: 'PDF section')),
  Module(
      moduleName: "Live Exam",
      route: LiveExamSubjectScreen(groupName: 'Live Exam')),
];
