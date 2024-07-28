import 'dart:io';

import 'package:egalee_admin/componants/datepicker_dialog.dart';
import 'package:egalee_admin/utlils/utlils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../componants/date_fomat.dart';
import '../../../data/firebase_caller/storage/upload.dart';
import '/data/firebase_caller/firestore/firestore_caller.dart';

class AddNewJobScreen extends StatefulWidget {
  const AddNewJobScreen(
      {super.key, required this.category, required this.subcategory,this.jobId, this.documentData});
  final String category;
  final String subcategory;
  final String? jobId;
  final dynamic documentData;

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
     _titleController.text=widget.documentData?['title']??'';
    _subtitleController.text=widget.documentData?['subtitle']??'';
    _applinkController.text=widget.documentData?['apply_link']??'';
    _descriptionController.text=widget.documentData?['description']??'';
    _locationController.text=widget.documentData?['location']??'';
    _sourceController.text=widget.documentData?['source']??'';
    publishDate=DateTime.tryParse(widget.documentData?['publishDate']??'');
    deadlineDate=DateTime.tryParse(widget.documentData?['deadlineDate']??'');
    imagelink=widget.documentData?['image']??"";
    _islocked=widget.documentData?['islocked']??false;
    super.initState();
  }

  File? _file;

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
                    decoration: InputDecoration(
                        labelText:
                            imagelink == null ? 'Pick a File' : '$imagelink'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Locked Content"),
                    Checkbox(
                        value: _islocked,
                        onChanged: (value) {
                          setState(() {
                            _islocked = !_islocked;
                          });
                        })
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed:()=>widget.jobId==null? _addNewJob():_updateSubCollectionDocument(context),
                  child: const Text('Save'),
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
      'islocked': _islocked,
      'timestamp': Timestamp.fromDate(DateTime.now()),
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
      sendPushNotification(_titleController.text, _descriptionController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job Category added to Firestore')),
        );
        // Clear text fields after adding data
        clearControllerData();
       Navigator.pop(context); 
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
          .doc(widget.subcategory.replaceAll(' ', ''))
          .collection('allposts')
         .doc(widget.jobId).update( inptudata()).then((value) {
      // Document successfully added
      Navigator.pop(context); // Close the current screen
    }).catchError((error) {
      // Error adding document
      // Handle error according to your app's requirements
    });
    
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
