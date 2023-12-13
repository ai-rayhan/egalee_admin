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
                physics: NeverScrollableScrollPhysics(),
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
    required this.id,
    required this.moduleName,
  });

  final String moduleName;
  final String id;
}

List<Module> modules = [
  Module(id: '1', moduleName: "Unit-A"),
  Module(id: '2', moduleName: "Unit-B"),
  Module(id: '2', moduleName: "Unit-C"),
  Module(id: '2', moduleName: "Unit-D"),
];
