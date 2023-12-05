import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egalee_admin/data/firebase_caller/storage/upload.dart';
import 'package:flutter/material.dart';

class AddModuleScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController imageLinkController = TextEditingController();

  void _addCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance.collection('skillcareer').add({
      'title': titleController.text,
      'subtitle': subtitleController.text,
      'imageLink': imageLinkController.text,
      // Add other fields as needed
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
        title: Text('Add Collection Document'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _addCollectionDocument(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: subtitleController,
              decoration: InputDecoration(labelText: 'Subtitle'),
            ),
            TextField(
              controller: imageLinkController,
              decoration: InputDecoration(labelText: 'Image Link'),
            ),
            // Add more TextFields for additional fields if needed
          ],
        ),
      ),
    );
  }
}

class AddTopicScreen extends StatefulWidget {
  final String documentId;

  AddTopicScreen({Key? key, required this.documentId}) : super(key: key);

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
        .collection('skillcareer')
        .doc(widget.documentId)
        .collection('topics')
        .add({
      'title': titleController.text,
      'subtitle': subtitleController.text,
      'description': descriptionController.text,
      'videoLink': videoLinkController.text,
      'pdfLink': imagelink,
      'timestamp': Timestamp.fromDate(DateTime.now()),
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
        title: Text('Add Topic'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _addSubCollectionDocument(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: subtitleController,
              decoration: InputDecoration(labelText: 'Subtitle'),
            ),
                const SizedBox(height: 10,),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
                const SizedBox(height: 10,),
            TextField(
              controller: videoLinkController,
              decoration: InputDecoration(labelText: 'Video Link'),
            ),
                const SizedBox(height: 10,),
            GestureDetector(
              onTap: () async {
                await pickFile(); // Pick file using file_picker
                if (_file != null) {
                  await uploadFile();
                }
              },
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                    labelText:
                        imagelink == null ? 'Pick a File' : '$imagelink'),
              ),
            ),
            // Add more TextFields for additional fields if needed
          ],
        ),
      ),
    );
  }
}
