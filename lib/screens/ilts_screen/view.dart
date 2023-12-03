import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add.dart';

class ModuleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Modules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddModuleScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('ilts').get(),
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
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var document = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicListScreen(
                          documentId: document.id,
                          moduleName: document['title'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(document['title']),
                      subtitle: Text(document['subtitle']),
                      // leading: Image.network(document['imageLink']),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class TopicListScreen extends StatelessWidget {
  final String documentId;
  final String moduleName;

  const TopicListScreen(
      {Key? key, required this.documentId, required this.moduleName})
      : super(key: key);
  // Future<void> _deleteTopic(id) async {
  //   await FirebaseFirestore.instance
  //       .collection('ilts')
  //       .doc(documentId)
  //       .collection('topics')
  //       .doc(id)
  //       .delete();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(moduleName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTopicScreen(documentId: documentId),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('ilts')
            .doc(documentId)
            .collection('topics')
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
                                _deleteTopic(subDocumentId, context);
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

  Future<void> _deleteTopic(id, BuildContext context) async {
    // Show a loading indicator while deleting
    showLoadingDialog(context);

    try {
      await FirebaseFirestore.instance
          .collection('ilts')
          .doc(documentId)
          .collection('topics')
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

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text('Deleting...'),
              ],
            ),
          ),
        );
      },
    );
  }
}
