import '../common_screen/view/all_topic_screen.dart';
import 'package:flutter/material.dart';



class DUAdmissionScreen extends StatelessWidget {
  const DUAdmissionScreen({super.key, required this.screenName});
  final String screenName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenName),
        
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
                            builder: (BuildContext context) => AllTopicScreen(
                                  groupName: modules[index].moduleName,
                                  subjectId: 'nosubject',
                                  subjectName: modules[index].moduleName,
                                )),
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
    required this.id,
    required this.moduleName,
  });

  final String moduleName;
  final String id;
}

List<Module> modules = [
  const Module(id: '1', moduleName: "Unit-A"),
  const Module(id: '2', moduleName: "Unit-B"),
  const Module(id: '2', moduleName: "Unit-C"),
  const Module(id: '2', moduleName: "Unit-D"),
];
