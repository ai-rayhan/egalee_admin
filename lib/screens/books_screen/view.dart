

import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({
    Key? key,
    required this.moduleName,
  }) : super(key: key);

  final String moduleName;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(moduleName));
  }
}

class Module {
  const Module({
    Key? key,
    required this.moduleName,
    required this.moduleIcon,
  });

  final String moduleName;
  final IconData moduleIcon;
}

List<Module> modules = [
  const Module(
    moduleName: "Free",
    moduleIcon: Icons.storm_rounded,
  ),
  const Module(
    moduleName: "Best",
    moduleIcon: Icons.language,
  ),
  const Module(
    moduleName: "Recomended",
    moduleIcon: Icons.work,
  ),
];
