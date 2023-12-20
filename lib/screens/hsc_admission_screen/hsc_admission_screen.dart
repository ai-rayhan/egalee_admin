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
      moduleName: "HSC Preparation",
      route: HscprepScreen(screenName: 'HSC Preparation')),
  const Module(
      moduleName: "Admission Question Bank",
      route: AllSubjectScreen(groupName: 'Admission Question Bank')),
  const Module(
      moduleName: "DU Admission",
      route: DUAdmissionScreen(screenName: 'DU Admission')),
  const Module(
      moduleName: "GST Admission",
      route: AllSubjectScreen(groupName: 'GST Admission')),
  const Module(
      moduleName: "Written Preparation",
      route: AllSubjectScreen(groupName: 'Written Preparation')),
  const Module(
      moduleName: "Medical Admission",
      route: AllSubjectScreen(groupName: 'Medical Admission')),

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
