
import 'package:egalee_admin/screens/books_screen/view/booklist_screen.dart';
import 'package:egalee_admin/screens/books_screen/view.dart';
import 'package:flutter/material.dart';



class SuggestionScreen extends StatelessWidget {
  const SuggestionScreen({
    super.key,
    required this.categoryDocId,
  });
  final String categoryDocId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Suggestion'),
        ),
        body: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => BookListScreen(
                          categorydocId: categoryDocId,
                          suggetionName: modules[index].moduleName,
                        ),
                      ),
                    );
                  },
                  child: ModuleCard(
                    moduleName: modules[index].moduleName,
                  ),
                ),
            separatorBuilder: (context, index) => Divider(),
            itemCount: modules.length));
  }
}