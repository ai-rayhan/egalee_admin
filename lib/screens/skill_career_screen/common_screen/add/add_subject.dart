import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egalee_admin/data/firebase_caller/storage/upload.dart';
import 'package:egalee_admin/models/subject.dart';
import 'package:flutter/material.dart';

class AddSubjectScreen extends StatefulWidget {
  AddSubjectScreen({super.key, required this.groupName,  this.subject});
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
    FirebaseFirestore.instance.collection('skillcareer').doc(widget.groupName).collection('allSubject').add({
      'title': titleController.text,
      'fee': feeController.text,
      'offerfee': offerFeeController.text,
      'pdflink':imagelink
    }).then((value) {
      // Document successfully added
      Navigator.pop(context); // Close the current screen
    }).catchError((error) {
      // Error adding document
      // Handle error according to your app's requirements
    });
  }
  void _updateCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance.collection('skillcareer').doc(widget.groupName).collection('allSubject').doc(widget.subject?.id).update({
      'title': titleController.text,
      'fee': feeController.text,
      'offerfee': offerFeeController.text,
      'pdflink':imagelink
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
    titleController.text=widget.subject?.title??'';
    feeController.text=widget.subject?.fee??'';
    offerFeeController.text=widget.subject?.offerfee??'';
    imagelink=widget.subject?.pdflink??'Pick a file';

    log(widget.groupName);
    log(widget.subject.toString());
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
            onPressed: () =>widget.subject==null? _addCollectionDocument(context):_updateCollectionDocument(context),
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
            ),  const SizedBox(height: 20,),
            // widget.groupName== "PDF section"?
            //  GestureDetector(
            //                     onTap: () async {
            //                       await pickFile(); // Pick file using file_picker
            //                       if (_file != null) {
            //                         await uploadFile();
            //                       }
            //                     },
            //                     child: TextFormField(
            //                       enabled: false,
            //                       decoration: InputDecoration(
            //                           labelText: imagelink == null
            //                               ? 'Pick a PDF'
            //                               : '$imagelink'),
            //                     ),
            //                   ):Container(),
            // widget.groupName=='Free course'||widget.groupName== "PDF section"?Container():Column(
            //   children: [
            //     TextField(
            //       controller: feeController,
            //       decoration: const InputDecoration(labelText: 'Course Fee'),
            //     ),
            //     const SizedBox(height: 20,),
            //     TextField(
            //       controller: offerFeeController,
            //       decoration: const InputDecoration(labelText: 'Offer Fee'),
            //     ),
            //   ],
            // ),

            // Add more TextFields for additional fields if needed
          ],
        ),
      ),
    );
  }
}
