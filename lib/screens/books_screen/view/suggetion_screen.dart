
import 'package:egalee_admin/screens/books_screen/add.dart';
import 'package:egalee_admin/screens/books_screen/view/booklist_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books Sub Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSubCategoryScreen(title: '',categoryId: categoryId),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
          .collection('books')
          .doc(categoryId)
          .collection('subcategory')
          .orderBy("title")
          .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No data available'),
            );
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var document = snapshot.data!.docs[index];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>BookListScreen(
                                  categorydocId: categoryId,
                                  subcategorydocId: document.id,
                                )),
                      );
                    },
                    child: ListTile(
                      title: Text(document['title']),
                      trailing: IconButton(
                          onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddSubCategoryScreen(title:document['title'],categoryId: categoryId,subcategoryId: document.id,),
                            ),
                          );
                          },
                          icon: Icon(Icons.edit)),
                    ));
              },
              separatorBuilder: (context, index) => Divider(),
            );
          }
        },
      ),
    );
  }

  // Future<void> deleteBookCategory(
  //   categorydocId,subcategorydocId,
  //   BuildContext context,
  // ) async {
  //   // Show a loading indicator while deleting
  //   showLoadingDialog(context);

  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('books')
  //         .doc(categorydocId)
  //         .collection('subcategory')
  //         .doc(subcategorydocId)
  //         .delete();

  //     // If deletion is successful, show a success Snackbar
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Topic deleted successfully'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   } catch (error) {
  //     // If there's an error, show an error Snackbar
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to delete topic: $error'),
  //         duration: const Duration(seconds: 3),
  //       ),
  //     );
  //   } finally {
  //     // Always pop the loading indicator
  //     Navigator.of(context, rootNavigator: true).pop();
  //   }
  // }
}



// import 'package:egalee_admin/screens/books_screen/view/booklist_screen.dart';
// import 'package:egalee_admin/screens/books_screen/view.dart';
// import 'package:flutter/material.dart';



// class SuggestionScreen extends StatelessWidget {
//   const SuggestionScreen({
//     super.key,
//     required this.categoryDocId,
//   });
//   final String categoryDocId;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('All Suggestion'),
//         ),
//         body: ListView.separated(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) => GestureDetector(
//                   onTap: () {
//                     Navigator.push<void>(
//                       context,
//                       MaterialPageRoute<void>(
//                         builder: (BuildContext context) => BookListScreen(
//                           categorydocId: categoryDocId,
//                           suggetionName: modules[index].moduleName,
//                         ),
//                       ),
//                     );
//                   },
//                   child: ModuleCard(
//                     moduleName: modules[index].moduleName,
//                   ),
//                 ),
//             separatorBuilder: (context, index) => Divider(),
//             itemCount: modules.length));
//   }
// }