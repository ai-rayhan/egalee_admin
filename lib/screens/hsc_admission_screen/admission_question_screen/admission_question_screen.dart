import 'package:flutter/material.dart';

class AdmissionQuestionBank extends StatelessWidget {
  const AdmissionQuestionBank({super.key, required this.screenName});
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
                      // Navigator.push<void>(
                      //   context,
                      //   MaterialPageRoute<void>(
                      //       builder: (BuildContext context) => module.route),
                      // );
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
  });

  final String moduleName;
}

List<Module> modules = [
  Module(
    moduleName: "bangla",
  ),
  Module(
    moduleName: "english",
  ),
];
