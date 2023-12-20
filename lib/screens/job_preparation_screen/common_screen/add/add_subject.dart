import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSubjectScreen extends StatelessWidget {
  AddSubjectScreen({super.key, required this.groupName});
  final String groupName;
  final TextEditingController titleController = TextEditingController();
  void _addCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance.collection('jobprep').doc(groupName).collection('allSubject').add({
      'title': titleController.text,
    }).then((value) {
      // Document successfully added
      Navigator.pop(context); // Close the current screen
    }).catchError((error) {
      // Error adding document
      // Handle error according to your app's requirements
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add A Subject in $groupName'),
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
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),

            // Add more TextFields for additional fields if needed
          ],
        ),
      ),
    );
  }
}
