import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/data/firebase_caller/firestore/firestore_caller.dart';

class AddJobCategoryScreen extends StatefulWidget {
  const AddJobCategoryScreen({super.key, required this.category, this.title, this.imageLink, this.id});
  final String category;
  final String? title;
  final String? imageLink;
  final String? id;

  @override
  _AddJobCategoryScreenState createState() => _AddJobCategoryScreenState();
}

class _AddJobCategoryScreenState extends State<AddJobCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _subtitleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    // _subtitleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _titleController.text=widget.title??'';
    imagelink=widget.imageLink??"pick a image";
    super.initState();
  }

  File? _file;
  String? imagelink;
  Future<void> uploadFile() async {
    try {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Uploading')));
      String fileName = _file!.path.split('/').last; // Extract file name
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(
          _file!, SettableMetadata(contentType: 'text/plain'));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        imagelink = downloadURL;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Upload Success')));
      print("File uploaded. Download URL: $downloadURL");
    } catch (e) {
      print("Error uploading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred while uploading')));
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    } else {
      print("No file selected");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Job Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Title';
                  }
                  return null;
                },
              ),
                  const SizedBox(height: 10,),
              // TextFormField(
              //   controller: _subtitleController,
              //   decoration: const InputDecoration(labelText: 'Subtitle'),
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return 'Please enter Subtitle';
              //     }
              //     return null;
              //   },
              // ),    const SizedBox(height: 10,),
                GestureDetector(
                  onTap: () async {
                    await pickFile(); // Pick file using file_picker
                    if (_file != null) {
                      await uploadFile();
                    }
                  },
                  child: TextFormField(
                    enabled: false,
                    decoration:  InputDecoration(labelText: imagelink),
                  ),
                ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed:()=> widget.id==null? _addJobCategoryToFirestore():_updateSubCollectionDocument(context),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addJobCategoryToFirestore() {
    if (_formKey.currentState!.validate()) {
      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('job_circular')
          .doc(widget.category.replaceAll(' ', ''))
          .collection('subcategory');
      var data = {
        'title': _titleController.text,
        // 'subtitle': _subtitleController.text,
        'image': imagelink
      };
      PostRequest.execute(collectionReference, data).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job Category added to Firestore')),
        );
        // Clear text fields after adding data

        _titleController.clear();
        // _subtitleController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Job Category: $error')),
        );
      });
    }
  }
   void _updateSubCollectionDocument(BuildContext context) {
   FirebaseFirestore.instance
          .collection('job_circular')
          .doc(widget.category.replaceAll(' ', ''))
          .collection('subcategory')
        .doc(widget.id).update({
      'title': _titleController.text,
      'image': imagelink,
      
      // Add other fields as needed
    }).then((value) {
      Navigator.pop(context); // Close the current screen
    }).catchError((error) {
      // Error adding document
      // Handle error according to your app's requirements
    });
  }
}
