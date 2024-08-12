import 'package:egalee_admin/componants/dialogs/deleting_dialog.dart';
import 'package:egalee_admin/screens/books_screen/add.dart';
import 'package:egalee_admin/screens/books_screen/view/suggetion_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BooksCategoriesScreen extends StatelessWidget {
  const BooksCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBooksCategoryScreen(title: '',),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('books').get(),
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
                            builder: (context) => SubCategoriesScreen(
                                   categoryId:document.id,
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
                              builder: (context) => AddBooksCategoryScreen(title:document['title'],categoryId:document.id),
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

  Future<void> deleteBookCategory(
    categorydocId,
    BuildContext context,
  ) async {
    // Show a loading indicator while deleting
    showLoadingDialog(context);

    try {
      await FirebaseFirestore.instance
          .collection('books')
          .doc(categorydocId)
          .delete();

      // If deletion is successful, show a success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Topic deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // If there's an error, show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete topic: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      // Always pop the loading indicator
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}


