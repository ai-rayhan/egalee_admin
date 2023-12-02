import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/data/firebase_caller/firestore/firestore_caller.dart';

class AddNewJobScreen extends StatefulWidget {
  const AddNewJobScreen(
      {super.key, required this.category, required this.subcategory});
  final String category;
  final String subcategory;

  @override
  _AddNewJobScreenState createState() => _AddNewJobScreenState();
}

class _AddNewJobScreenState extends State<AddNewJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  // String? _imgUrl;
  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  File? _file;

  Future<void> uploadFile() async {
    try {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Uploading')));
      String fileName = _file!.path.split('/').last; // Extract file name
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(
          _file!, SettableMetadata(contentType: 'text/plain'));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        _imageController.text = downloadURL;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Upload Success')));
      print("File uploaded. Download URL: $downloadURL");
    } catch (e) {
      print("Error uploading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while uploading')));
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
        title: Text('Add Job Category'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _subtitleController,
                decoration: InputDecoration(labelText: 'Subtitle'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Subtitle';
                  }
                  return null;
                },
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
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
            ),
              // TextFormField(
              //   controller: _imageController,
              //   decoration: InputDecoration(labelText: 'Image URL'),
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return 'Please enter Image URL';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _addJobCategoryToFirestore,
                child: Text('Add Job Category'),
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
          .collection('subcategory')
          .doc(widget.subcategory.replaceAll(' ', ''))
          .collection('allposts');
      var data = {
        'id': _idController.text,
        'title': _titleController.text,
        'subtitle': _subtitleController.text,
        'image': _imageController.text,
      };
      PostRequest.execute(collectionReference, data).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Job Category added to Firestore')),
        );
        // Clear text fields after adding data
        _idController.clear();
        _titleController.clear();
        _subtitleController.clear();
        _imageController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Job Category: $error')),
        );
      });
    }
  }
}
