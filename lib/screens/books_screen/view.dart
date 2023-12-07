import 'package:egalee_admin/componants/dialogs/deleting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add.dart';

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
                  builder: (context) => AddBooksCategoryScreen(),
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
                            builder: (context) => SuggestionScreen(
                                  categoryDocId: document.id,
                                )),
                      );
                    },
                    child: ListTile(
                      title: Text(document['title']),
                      trailing: IconButton(
                          onPressed: () {
                            deleteBookCategory(document.id, context);
                          },
                          icon: Icon(Icons.delete)),
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
                  child: Text("All Topics"),
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
                          trailing: IconButton(
                              onPressed: () {
                                _deleteBook(
                                    subDocumentId,
                                    context,
                                    subDocument['pdfLink'] ?? '',
                                    subDocument['videoLink'] ?? '');
                              },
                              icon: const Icon(Icons.delete)),
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
