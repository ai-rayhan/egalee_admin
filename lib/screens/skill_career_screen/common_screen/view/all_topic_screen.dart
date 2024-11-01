import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egalee_admin/data/firebase_caller/storage/delete.dart';
import 'package:egalee_admin/models/topic.dart';
import 'package:egalee_admin/screens/skill_career_screen/common_screen/add/add_topic_screen.dart';
import 'package:flutter/material.dart';

import '../../../../componants/dialogs/deleting_dialog.dart';


class AllTopicScreen extends StatelessWidget {
  const AllTopicScreen(
      {super.key,
      required this.groupName,
      required this.subjectId,
      required this.subjectName});
  final String groupName;
  final String subjectId;
  final String subjectName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(subjectName),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTopicScreen(
                      groupName: groupName,
                      subjectId: subjectId,
                      subjectName: subjectName,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('skillcareer')
              .doc(groupName)
              .collection('allSubject')
              .doc(subjectId)
              .collection('alltopics')
              .orderBy("timestamp")
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
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("$subjectName/All subjects "),
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
                                    subDocumentId,subDocument,
                                    context,
                                  );
                                },
                                icon: const Icon(Icons.delete)),
                            onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddTopicScreen(
                                        topic: Topic(
                                          id: subDocumentId,
                                          title:subDocument['title'],description: subDocument['description'] ,videoLink: subDocument['videoLink'],pdfLink:  subDocument['pdfLink'],mcqlink: subDocument['quizLink'],duration: (subDocument.data() as Map<String, dynamic>).containsKey('duration') ? subDocument['duration'] : null,),
                                        groupName: groupName,
                                        subjectId: subjectId,
                                        subjectName: subjectName,
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
        ));
  }

  Future<void> _deleteTopic(id,QueryDocumentSnapshot<Object?>subDocument, BuildContext context) async {
    // Show a loading indicator while deleting
    showLoadingDialog(context);

    try {
      await FiledeleteUtils.deleteImageFromFirebaseStorage(subDocument['pdfLink']);
      await FirebaseFirestore.instance.collection('skillcareer')
          .doc(groupName)
          .collection('allSubject')
          .doc(subjectId)
          .collection('alltopics')
          .doc(id)
          .delete();
      
      // If deletion is successful, show a success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(' deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // If there's an error, show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete : $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      // Always pop the loading indicator
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
