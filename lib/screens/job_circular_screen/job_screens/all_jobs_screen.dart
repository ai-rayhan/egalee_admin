import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../data/firebase_caller/storage/delete.dart';
import 'add_new_job_screen.dart';
import 'job_details_screen.dart';

class AllJobScreen extends StatefulWidget {
  const AllJobScreen(
      {super.key, required this.category, required this.subcategoryId});
  final String category;
  final String subcategoryId;

  @override
  State<AllJobScreen> createState() => _AllJobScreenState();
}

class _AllJobScreenState extends State<AllJobScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  deleteJobById(id,imageLink) async {
    await _firestore
        .collection('job_circular')
        .doc(widget.category.replaceAll(' ', ''))
        .collection('subcategory')
        .doc(widget.subcategoryId)
        .collection('allposts')
        .doc(id)
        .delete();
        await FiledeleteUtils.deleteImageFromFirebaseStorage(imageLink);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} Jobs"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => AddNewJobScreen(
                      category: widget.category,
                      subcategory: widget.subcategoryId,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('job_circular')
            .doc(widget.category.replaceAll(' ', ''))
            .collection('subcategory')
            .doc(widget.subcategoryId)
            .collection('allposts').orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // If data is available, display it
          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("All Posts"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    // Access individual document data using documents[index]
                    final documentData =
                        documents[index].data() as Map<String, dynamic>;
                    final jobId = documents[index].id;
                
                    // Display the data in whatever way you want, for example:
                    return ListTile(
                      title: Text(documentData['title']),
                      subtitle: Text(documentData['subtitle']),
                      onTap: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => JobDetailsScreen(
                              jobdata: documentData,
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(radius: 15,child: Text((index+1).toString()),),
                      trailing: GestureDetector(
                          onTap: () {
                            deleteJobById(jobId,documentData['image']??'');
                          },
                          child: const Icon(Icons.delete)),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
