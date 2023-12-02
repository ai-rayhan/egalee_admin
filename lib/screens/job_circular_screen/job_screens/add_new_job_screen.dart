import 'dart:io';

import 'package:egalee_admin/componants/datepicker_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../componants/date_fomat.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _applinkController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? publishDate;
  DateTime? deadlineDate;
  String? imagelink;
  bool _islocked = false;
  // String? _imgUrl;
  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _applinkController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _sourceController.dispose();
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
        title: const Text('Add New Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _subtitleController,
                  decoration: const InputDecoration(labelText: 'Subtitle'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Subtitle';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  maxLines: 5,
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _applinkController,
                  decoration: const InputDecoration(labelText: 'ApplyLink'),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _sourceController,
                  decoration: const InputDecoration(labelText: 'Source'),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Job Location'),
                ),
                const SizedBox(
                  height: 16,
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
                    decoration: const InputDecoration(labelText: 'Image URL'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    await pickDate(context).then((date) {
                      if (date != null) {
                        setState(() {
                          publishDate = date;
                        });
                      }
                    });
                  },
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        labelText: publishDate == null
                            ? 'Pick Publish Date'
                            : 'Publish Date: ${formatdate(publishDate)}'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    await pickDate(context).then((date) {
                      if (date != null) {
                        setState(() {
                          deadlineDate = date;
                        });
                      }
                    });
                  },
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        labelText: deadlineDate == null
                            ? 'Pick Deadline Date'
                            : 'Deadline Date: ${formatdate(deadlineDate)}'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _addNewJob,
                  child: const Text('Add New Job'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  inptudata() {
    return {
      'title': _titleController.text,
      'subtitle': _subtitleController.text,
      'description': _descriptionController.text,
      'apply_link': _applinkController.text,
      'source': _sourceController.text,
      'location': _locationController.text,
      'publishDate': publishDate?.toIso8601String() ?? '',
      'deadlineDate': deadlineDate?.toIso8601String() ?? '',
      'image': imagelink ?? '',
      'islocked': _islocked
    };
  }

  void _addNewJob() {
    if (_formKey.currentState!.validate()) {
      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('job_circular')
          .doc(widget.category.replaceAll(' ', ''))
          .collection('subcategory')
          .doc(widget.subcategory.replaceAll(' ', ''))
          .collection('allposts');

      PostRequest.execute(collectionReference, inptudata()).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job Category added to Firestore')),
        );
        // Clear text fields after adding data
        clearControllerData();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Job Category: $error')),
        );
      });
    }
  }

  clearControllerData() {
    _applinkController.clear();
    _titleController.clear();
    _subtitleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _sourceController.clear();
  }
}
