import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egalee_admin/data/firebase_caller/storage/delete.dart';
import 'package:egalee_admin/models/subject.dart';
import 'package:egalee_admin/screens/job_preparation_screen/common_screen/add/add_subject.dart';
import 'package:egalee_admin/screens/job_preparation_screen/common_screen/view/all_topic_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../componants/dialogs/deleting_dialog.dart';

class AllSubjectScreen extends StatelessWidget {
  const AllSubjectScreen({super.key, required this.groupName});
  final String groupName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(groupName),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddSubjectScreen(groupName: groupName),
                  ),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('jobprep')
              .doc(groupName)
              .collection('allSubject')
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text("$groupName/All subjects "),
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                         Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                           builder: (context) =>
                                               AddSubjectScreen(groupName: groupName,subject: Subject(id: subDocumentId, title:subDocument['title'] ,offerfee:subDocument['offerfee'],fee: subDocument['fee'], pdflink: (subDocument.data() as Map<String, dynamic>).containsKey('pdflink') ? subDocument['pdflink'] : null,),),
                                         ),
                                       );
                                    },
                                    icon: const Icon(Icons.edit)),

                                   groupName== "PDF section"? IconButton(onPressed: (){
                                      _deleteTopic(subDocumentId,subDocument, context);
                                    }, icon:Icon(Icons.delete)):Container()
                              ],
                            ),

                            onTap: () {
                              if(groupName== "PDF section"){
                                return;
                              }
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        AllTopicScreen(
                                          groupName: groupName,
                                          subjectId: subDocumentId, subjectName:subDocument['title'] ,
                                        )),
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
      await FiledeleteUtils.deleteImageFromFirebaseStorage((subDocument.data() as Map<String, dynamic>).containsKey('pdflink') ? subDocument['pdflink'] : null,);
      await FirebaseFirestore.instance
          .collection('jobprep')
          .doc(groupName)
          .collection('allSubject')
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
 
