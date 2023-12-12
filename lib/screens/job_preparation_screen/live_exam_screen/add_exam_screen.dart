import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egalee_admin/data/firebase_caller/storage/upload.dart';
import 'package:flutter/material.dart';

import '../../hsc_admission_screen/pdf_section_screen/create_quiz.dart';


class AddTopicScreen extends StatefulWidget {
  final String groupName;
  final String subjectId;
  final String subjectName;

  AddTopicScreen({Key? key, required this.groupName, required this.subjectId, required this.subjectName})
      : super(key: key);

  @override
  State<AddTopicScreen> createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController subtitleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController pdfLinkController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  void _addSubCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance
        .collection('jobprep')
        .doc(widget.groupName)
        .collection('allSubject')
        .doc(widget.subjectId)
        .collection('alltopics')
        .add({
      'title': titleController.text,
      'subtitle': subtitleController.text,
      'description': descriptionController.text,
      'time': imagelink,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'quizLink': quizfileLink,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exam In ${widget.subjectName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _addSubCollectionDocument(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: subtitleController,
                decoration: InputDecoration(labelText: 'Subtitle'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 5,
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
          
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: timeController,
                decoration: InputDecoration(labelText: "Exam Time in minute"),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizInputPage()),
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
              )
              // Add more TextFields for additional fields if needed
            ],
          ),
        ),
      ),
    );
  }
}
