import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egalee_admin/models/subject.dart';
import 'package:flutter/material.dart';

class AddSubjectScreen extends StatefulWidget {
  AddSubjectScreen({super.key, required this.groupName, this.subject});
  final String groupName;
  final Subject? subject;

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController feeController = TextEditingController();

  final TextEditingController offerFeeController = TextEditingController();

  void _addCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance.collection('hscadmission').doc(widget.groupName).collection('allSubject').add({
      'title': titleController.text,
      'fee': feeController.text,
      'offerfee': offerFeeController.text,
    }).then((value) {
      // Document successfully added
      Navigator.pop(context); // Close the current screen
    }).catchError((error) {
      // Error adding document
      // Handle error according to your app's requirements
    });
  }
  void _updeteCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance.collection('hscadmission').doc(widget.groupName).collection('allSubject').doc(widget.subject?.id).update({
      'title': titleController.text,
      'fee': feeController.text,
      'offerfee': offerFeeController.text,
    }).then((value) {
      // Document successfully added
      Navigator.pop(context); // Close the current screen
    }).catchError((error) {
      // Error adding document
      // Handle error according to your app's requirements
    });
  }

@override
  void initState() {
    titleController.text=widget.subject?.title??'';
    feeController.text=widget.subject?.fee??'';
    offerFeeController.text=widget.subject?.offerfee??'';
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add A Subject in ${widget.groupName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () =>widget.subject==null? _addCollectionDocument(context):_updeteCollectionDocument(context),
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
              decoration: const InputDecoration(labelText: 'Course Name '),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: feeController,
              decoration: const InputDecoration(labelText: 'Course Fee'),
            ),const SizedBox(height: 20,),
            TextField(
              controller: offerFeeController,
              decoration: const InputDecoration(labelText: 'Offer Fee'),
            ),

            // Add more TextFields for additional fields if needed
          ],
        ),
      ),
    );
  }
}
