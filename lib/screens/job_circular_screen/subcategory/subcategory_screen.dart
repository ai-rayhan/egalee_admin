import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egalee_admin/screens/job_circular_screen/subcategory/add_subcategory_screen.dart';
import 'package:flutter/material.dart';

import '../all_jobs_screen.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key, required this.category});
  final String category;

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} subcategoryList"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        AddJobCategoryScreen(category: widget.category),
                  ),
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('job_circular')
            .doc(widget.category.replaceAll(' ', ''))
            .collection('subcategory')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // If data is available, display it
          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              // Access individual document data using documents[index]
              final documentData =
                  documents[index].data() as Map<String, dynamic>;

              // Display the data in whatever way you want, for example:
              return ListTile(
                title: Text(documentData['title']),
                subtitle: Text(documentData['subtitle']),
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => AllJobScreen(
                        category: widget.category,
                        subcategoryId: documents[index].id,
                      ),
                    ),
                  );
                },
                // leading: Image.network(documentData['image']),
                // Other widgets to display additional data
              );
            },
          );
        },
      ),
    );
  }
}
