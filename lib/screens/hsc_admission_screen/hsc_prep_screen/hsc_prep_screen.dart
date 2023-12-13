import 'package:flutter/material.dart';

import '../common_screen/view/all_subject_screen.dart';

class HscprepScreen extends StatelessWidget {
  const HscprepScreen({super.key, required this.screenName});
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
                            builder: (BuildContext context) => AllSubjectScreen(
                                  groupName: modules[index].moduleName,
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
  Module(id: '1', moduleName: "মানবিক"),
  Module(id: '2', moduleName: "বিজ্ঞান"),
  Module(id: '2', moduleName: "ব্যবসায়"),
];
