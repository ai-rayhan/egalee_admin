import 'package:egalee_admin/utlils/utlils.dart';
import 'package:flutter/material.dart';

import 'subcategorylist_screens/subcategory_screen.dart';

class JobCategoryScreen extends StatelessWidget {
  const JobCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category"),
      ),
      body: ListView.builder(
        itemCount: AppStaticData.jobMainCategory.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => SubCategoryListScreen(
                    category: AppStaticData.jobMainCategory[index],
                  ),
                ),
              );
            },
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(AppStaticData.jobMainCategory[index]),
            )),
          );
        },
      ),
    );
  }
}
