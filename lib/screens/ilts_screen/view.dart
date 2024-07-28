import 'package:egalee_admin/data/firebase_caller/storage/delete.dart';
import 'package:egalee_admin/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add.dart';

class ModuleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Modules'),
        ),
        body: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => TopicListScreen(
                        documentId:
                            modules[index].moduleName.replaceAll(' ', ''),
                        moduleName: modules[index].moduleName,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(modules[index].moduleIcon),
                  title: Text(modules[index].moduleName),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                UpdatePriceScreen(
                              documentId:
                                  modules[index].moduleName.replaceAll(' ', ''),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit)),
                )),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: modules.length));
  }
}

class TopicListScreen extends StatelessWidget {
  final String documentId;
  final String moduleName;

  const TopicListScreen(
      {Key? key, required this.documentId, required this.moduleName})
      : super(key: key);

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
                          // subtitle: Text(subDocument['subtitle']),
                          trailing: IconButton(
                              onPressed: () {
                                _deleteTopic(
                                    subDocumentId,
                                    context,
                                    subDocument['pdfLink'] ?? '',
                                    subDocument['videoLink'] ?? '');
                              },
                              icon: const Icon(Icons.delete)),
                          onTap: () {
                               Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddTopicScreen(
                                        topic: Topic(
                                          id: subDocumentId,
                                          title:subDocument['title'],description: subDocument['description'] ,videoLink: subDocument['videoLink'],pdfLink:  subDocument['pdfLink'],), documentId: documentId,
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

  Future<void> _deleteTopic(
      id, BuildContext context, videoLink, pdfLink) async {
    // Show a loading indicator while deleting
    showLoadingDialog(context);

    try {
      await FirebaseFirestore.instance
          .collection('ilts')
          .doc(documentId)
          .collection('topics')
          .doc(id)
          .delete();
      await FiledeleteUtils.deleteImageFromFirebaseStorage(videoLink);
      await FiledeleteUtils.deleteImageFromFirebaseStorage(pdfLink);
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
    moduleName: "Reading Module",
    moduleIcon: Icons.sticky_note_2_rounded,
  ),
  const Module(
    moduleName: "Writing Module",
    moduleIcon: Icons.edit_note_outlined,
  ),
  const Module(
    moduleName: "Listening Module",
    moduleIcon: Icons.hearing,
  ),
  const Module(
    moduleName: "Speaking Module",
    moduleIcon: Icons.mic,
  ),
  const Module(
    moduleName: "Scholarship Info",
    moduleIcon: Icons.school,
  ),
  const Module(
    moduleName: "Visa Processing",
    moduleIcon: Icons.wifi_protected_setup,
  ),
];


class UpdatePriceScreen extends StatefulWidget {
  final String documentId;

  UpdatePriceScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  _UpdatePriceScreenState createState() => _UpdatePriceScreenState();
}

class _UpdatePriceScreenState extends State<UpdatePriceScreen> {
  late TextEditingController regularFeeController;
  late TextEditingController offerFeeController;

  @override
  void initState() {
    super.initState();
    regularFeeController = TextEditingController();
    offerFeeController = TextEditingController();
    _fetchData();
  }

  void _fetchData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('ilts')
          .doc(widget.documentId)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          regularFeeController.text = documentSnapshot['fee'] ?? '';
          offerFeeController.text = documentSnapshot['offerfee'] ?? '';
          // Set other fields if needed
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  void _addCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance.collection('ilts').doc(widget.documentId).set({
      'fee': regularFeeController.text,
      'offerfee': offerFeeController.text,
      // Add other fields as needed
    }).then((value) {
      // Document successfully added
      Navigator.pop(context); // Close the current screen
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Collection Document'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _addCollectionDocument(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: regularFeeController,
              decoration: const InputDecoration(labelText: 'Regular fee'),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: offerFeeController,
              decoration: const InputDecoration(labelText: 'Offer fee'),
            ),
            // Add more TextFields for additional fields if needed
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    regularFeeController.dispose();
    offerFeeController.dispose();
    super.dispose();
  }
}
