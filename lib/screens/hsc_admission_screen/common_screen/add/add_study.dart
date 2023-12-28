import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egalee_admin/data/firebase_caller/storage/upload.dart';
import 'package:flutter/material.dart';

import '../../../../componants/explanation_quiz_create.dart';

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

  // final TextEditingController subtitleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController videoLinkController = TextEditingController();

  final TextEditingController pdfLinkController = TextEditingController();

  void _addSubCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance
        .collection('hscadmission')
        .doc(widget.groupName)
        .collection('allSubject')
        .doc(widget.subjectId)
        .collection('alltopics')
        .add({
      'title': titleController.text,
      // 'subtitle': subtitleController.text,
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

  bool onlyMCQ() {
    if (widget.groupName == 'Admission Question Bank' ||
        widget.groupName == 'GST Admission') {
      return true;
    } else {
      return false;
    }
  }

  bool nonPdf() {
    if (widget.groupName == 'DU Admission' ||
        widget.groupName == 'Video section') {
      return true;
    } else {
      return false;
    }
  }

  bool nonmcq() {
    if (widget.groupName == 'Written Preparation' ||
        widget.groupName == 'Video section' ||
        widget.groupName == 'PDF section') {
      return true;
    } else {
      return false;
    }
  }

  // bool nonDescription() {
  //   if (widget.groupName == 'Medical Admission' ||
  //       widget.groupName == 'Written Preparation' ||
  //       widget.groupName == 'DU Admission' ||
  //       widget.groupName == 'PDF section' ||
  //       widget.groupName == 'Video section') {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  bool nonvideo() {
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
              onlyMCQ()
                  ? Container()
                  : TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
              const SizedBox(
                height: 10,
              ),

              // onlyMCQ() || nonDescription()
              //     ? Container()
              //     : TextField(
              //         maxLines: 5,
              //         controller: descriptionController,
              //         decoration:
              //             const InputDecoration(labelText: 'Description'),
              //       ),
              // const SizedBox(
              //   height: 10,
              // ),
              onlyMCQ() || nonvideo()
                  ? Container()
                  : TextField(
                      controller: videoLinkController,
                      decoration:
                          const InputDecoration(labelText: 'Video Link'),
                    ),
              const SizedBox(
                height: 10,
              ),
              onlyMCQ() || nonPdf()
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
              const SizedBox(
                height: 10,
              ),
              nonmcq()
                  ? Container()
                  : GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QuizInputPagewithExplanation()),
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
              // Add more TextFields for additional fields if needed
            ],
          ),
        ),
      ),
    );
  }
}
