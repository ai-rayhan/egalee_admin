import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egalee_admin/data/firebase_caller/storage/upload.dart';
import 'package:egalee_admin/models/book.dart';
import 'package:egalee_admin/utlils/utlils.dart';
import 'package:flutter/material.dart';

class AddBooksCategoryScreen extends StatefulWidget {

  AddBooksCategoryScreen({super.key, required this.title});
 final String title;
  @override
  State<AddBooksCategoryScreen> createState() => _AddBooksCategoryScreenState();
}

class _AddBooksCategoryScreenState extends State<AddBooksCategoryScreen> {
  final TextEditingController titleController = TextEditingController();

  void _addCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance.collection('books').add({
      'title': titleController.text,
      // 'subtitle': subtitleController.text,
      // 'imageLink': imageLinkController.text,
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
  void initState() {
    titleController.text=widget.title;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book Category'),
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
            // TextField(
            //   controller: subtitleController,
            //   decoration: InputDecoration(labelText: 'Subtitle'),
            // ),
            // TextField(
            //   controller: imageLinkController,
            //   decoration: InputDecoration(labelText: 'Image Link'),
            // ),
            // Add more TextFields for additional fields if needed
          ],
        ),
      ),
    );
  }
}

class AddBooksScreen extends StatefulWidget {
  final String documentId;
  final String suggetionCollectionName;
  final Book? book;

  AddBooksScreen(
      {Key? key,
      required this.documentId,
      required this.suggetionCollectionName, this.book})
      : super(key: key);

  @override
  State<AddBooksScreen> createState() => _AddBooksScreenState();
}

class _AddBooksScreenState extends State<AddBooksScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController writerController = TextEditingController();

  final TextEditingController pdflinkController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  // final TextEditingController pdfLinkController = TextEditingController();

  void _addSubCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance
        .collection('books')
        .doc(widget.documentId)
        .collection(widget.suggetionCollectionName)
        .add({
      'title': titleController.text,
      'subtitle':writerController.text,
      'description': pdflinkController.text,
      'videoLink': priceController.text,
      'pdfLink': imagelink,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      // Add other fields as needed
    }).then((value) {
        sendPushNotification(titleController.text, writerController.text);
      Navigator.pop(context); // Close the current screen
    }).catchError((error) {
      // Error adding document
      // Handle error according to your app's requirements
    });
  }
  void _updateSubCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance
        .collection('books')
        .doc(widget.documentId)
        .collection(widget.suggetionCollectionName)
        .doc(widget.book?.id).update ({
      'title': titleController.text,
      'subtitle':writerController.text,
      'description': pdflinkController.text,
      'videoLink': priceController.text,
      'pdfLink': imagelink,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      // Add other fields as needed
    }).then((value) {
        // sendPushNotification(titleController.text, writerController.text);
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
  void initState() {
    titleController.text=widget.book?.title??'';
    pdflinkController.text=widget.book?.pdflink??'';
    writerController.text=widget.book?.writerName??'';
    priceController.text=widget.book?.price??'';
    imagelink=widget.book?.imagelink??'pick image';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add A Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () =>widget.book==null? _addSubCollectionDocument(context):_updateSubCollectionDocument(context),
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
                controller: writerController,
                decoration: const InputDecoration(labelText: 'Writer Name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
              
                controller: pdflinkController,
                decoration: const InputDecoration(labelText: 'PDF Link'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(
                height: 10,
              ),
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
                          imagelink == null ? 'Pick a Image' : '$imagelink'),
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
