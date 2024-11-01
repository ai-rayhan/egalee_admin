import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egalee_admin/componants/explanation_quiz_create.dart';
import 'package:egalee_admin/componants/quiz_input_page.dart';
import 'package:egalee_admin/data/firebase_caller/storage/upload.dart';
import 'package:flutter/material.dart';

class AddExamScreen extends StatefulWidget {
  final String groupName;
  final dynamic document;
  final dynamic docId;

  AddExamScreen({
    Key? key,
    required this.groupName, this.document, this.docId,
  }) : super(key: key);

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  bool _islocked = false;
  bool _isresultPublished = false;
  void _addSubCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance
        .collection('hscadmission')
        .doc(widget.groupName)
        .collection('allexam')
        .add({
      'title': titleController.text,
      // 'subtitle': subtitleController.text,
      'description': descriptionController.text,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'quizLink': quizfileLink,
      'duration': durationController.text,
      'islocked': _islocked,
      'isresultPublished': _isresultPublished,

      // Add other fields as needed
    }).then((value) {
      // Document successfully added
      Navigator.pop(context); // Close the current screen
    }).catchError((error) {
      // Error adding document
      // Handle error according to your app's requirements
    });
  }
  void _updateSubCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance
        .collection('hscadmission')
        .doc(widget.groupName)
        .collection('allexam').doc(widget.docId)
        .update({
      'title': titleController.text,
      // 'subtitle': subtitleController.text,
      'description': descriptionController.text,
       'timestamp': widget.document['timestamp'],
      'quizLink': quizfileLink,
      'duration': durationController.text,
      'islocked': _islocked,
      'isresultPublished': _isresultPublished,



      // Add other fields as needed
    }).then((value) {
      // Document successfully added
      Navigator.pop(context); // Close the current screen
    }).catchError((error) {
      // Error adding document
      // Handle error according to your app's requirements
    });
  }

  File? _file;
  String? imagelink;
  String? quizfileLink;
  Future<void> uploadFile() async {
    String? downloadURL = await FileUploadUtils.uploadFile(context, _file);
    if (downloadURL != null) {
      setState(() {
        imagelink = downloadURL;
      });
    }
  }

  Future<void> pickFile() async {
    File? file = await FileUploadUtils.pickFile();
    if (file != null) {
      setState(() {
        _file = file;
      });
    }
  }
@override
  void initState() {
 titleController.text=widget.document?['title']??'';
 descriptionController.text=widget.document?['description']??'';
 durationController.text=widget.document?['duration']??'';
 quizfileLink=widget.document?['quizLink']??'Add MCQ';
 _isresultPublished=widget.document?['isresultPublished']??false; 
     super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add A Exam '),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () =>widget.document==null? _addSubCollectionDocument(context):_updateSubCollectionDocument(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(
                height: 10,
              ),
              // TextField(
              //   controller: subtitleController,
              //   decoration: const InputDecoration(labelText: 'Subtitle'),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              TextField(
                keyboardType: TextInputType.number,
                controller: durationController,
                decoration:
                    const InputDecoration(labelText: 'Duration in minute'),
              ),
              const SizedBox(
                height: 10,
              ),
              // TextField(
              //   maxLines: 5,
              //   controller: descriptionController,
              //   decoration: const InputDecoration(labelText: 'Description'),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),

              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuizInputPagewithExplanation(quizfileLink: quizfileLink,)),
                  );

                  if (result != null) {
                    setState(() {
                      quizfileLink = result;
                    });
                    debugPrint('Received data from Screen : $result');
                  }
                },
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      labelText:
                          quizfileLink == null ? 'Add MCQ' : quizfileLink!),
                ),
              ),

              // Add more TextFields for additional fields if needed
            ],
          ),
        ),
      ),
    );
  }
}
