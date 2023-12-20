import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egalee_admin/data/firebase_caller/storage/upload.dart';
import 'package:flutter/material.dart';

import '../../../../componants/create_quiz.dart';

class AddTopicScreen extends StatefulWidget {
  final String groupName;
  final String subjectId;
  final String subjectName;

  const AddTopicScreen(
      {Key? key,
      required this.groupName,
      required this.subjectId,
      required this.subjectName})
      : super(key: key);

  @override
  State<AddTopicScreen> createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController subtitleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController videoLinkController = TextEditingController();

  final TextEditingController pdfLinkController = TextEditingController();

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
      'videoLink': videoLinkController.text,
      'pdfLink': imagelink,
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

  bool checkOnlyMCQ() {
    if (widget.groupName == 'Job Solution' ||
        widget.groupName == 'BCS Preparation' ||
        widget.groupName == 'NTRCA & Primary Preparation' ||
        widget.groupName == 'Bank Job Preparation') {
      return true;
    } else {
      return false;
    }
  }

  bool checkonlyVideo() {
    if (widget.groupName == 'Written Preparation' ||
        widget.groupName == 'Video section') {
      return true;
    } else {
      return false;
    }
  }

  bool nonpdf() {
    if (widget.groupName == 'Viva Preparation') {
      return true;
    } else {
      return false;
    }
  }

  bool nonMCQ() {
    if (widget.groupName == 'PDF section') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Study In ${widget.subjectName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _addSubCollectionDocument(context),
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
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(labelText: 'Subtitle'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 5,
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              checkOnlyMCQ()
                  ? Container()
                  : Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        widget.groupName == 'PDF section'
                            ? Container()
                            : TextField(
                                controller: videoLinkController,
                                decoration: const InputDecoration(
                                    labelText: 'Video Link'),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        checkonlyVideo() || nonpdf()
                            ? Container()
                            : GestureDetector(
                                onTap: () async {
                                  await pickFile(); // Pick file using file_picker
                                  if (_file != null) {
                                    await uploadFile();
                                  }
                                },
                                child: TextFormField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                      labelText: imagelink == null
                                          ? 'Pick a PDF'
                                          : '$imagelink'),
                                ),
                              ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              checkonlyVideo() || nonMCQ()
                  ? Container()
                  : GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuizInputPage()),
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
                            labelText: quizfileLink == null
                                ? 'Add MCQ'
                                : quizfileLink!),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
