
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egalee_admin/componants/dialogs/deleting_dialog.dart';
import 'package:egalee_admin/models/book.dart';
import 'package:egalee_admin/screens/books_screen/add.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BookListScreen extends StatelessWidget {
  final String categorydocId;
  final String suggetionName;

  const BookListScreen(
      {Key? key, required this.categorydocId, required this.suggetionName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(suggetionName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBooksScreen(
                    documentId: categorydocId,
                    suggetionCollectionName: suggetionName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('books')
            .doc(categorydocId)
            .collection(suggetionName)
            .orderBy('timestamp', descending: true)
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("All Books"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var subDocument = snapshot.data!.docs[index];
                      var subDocumentId = snapshot.data!.docs[index].id;
                      return Card(
                        child: ListTile(
                          title: Text(subDocument['title']),
                          subtitle: Text(subDocument['subtitle']),
                          trailing: GestureDetector(
                              onTap: () {
                                _deleteBook(
                                    subDocumentId,
                                    context,
                                    subDocument['pdfLink'] ?? '',
                                    subDocument['videoLink'] ?? '');
                              },
                              child: const Icon(Icons.delete,size: 25,)),
                                 onTap: () {
                                    Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AddBooksScreen(
                                                    documentId: categorydocId,
                                                    suggetionCollectionName: suggetionName,
                                                    book: Book(
                                                      id: subDocumentId,
                                                      title: subDocument['title'],pdflink: subDocument['description'],imagelink: subDocument['pdfLink'],price: subDocument['videoLink'],writerName: subDocument['subtitle']),
                                                  ),
                                                ),
                                              );
                                    },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> _deleteBook(id, BuildContext context, videoLink, pdfLink) async {
    // Show a loading indicator while deleting
    showLoadingDialog(context);

    try {
      await FirebaseFirestore.instance
          .collection('books')
          .doc(categorydocId)
          .collection(suggetionName)
          .doc(id)
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