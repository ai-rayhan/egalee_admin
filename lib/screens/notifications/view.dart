import 'package:egalee_admin/utlils/utlils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showAddDialog(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var data = documents[index].data() as Map<String, dynamic>;
              var docId = documents[index].id;

              return ListTile(
                title: Text(data['title'] ?? 'No Title'),
                subtitle: Text(data['description'] ?? 'No Description'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showEditDialog(
                          context,
                          docId,
                          data['title'],
                          data['description'],
                          data['link'],
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteDocument(docId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final linkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Notification'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 8,),

              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 8,),

              TextField(
                controller: linkController,
                decoration: InputDecoration(labelText: 'Link'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: ()async {
               await addDocument(
                  titleController.text,
                  descriptionController.text,
                  linkController.text,
                );
                sendPushNotification(titleController.text, descriptionController.text,);  
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(
    BuildContext context,
    String docId,
    String title,
    String description,
    String link,
  ) {
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);
    final linkController = TextEditingController(text: link);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Notification'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 8,),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 8,),

              TextField(
                controller: linkController,
                decoration: InputDecoration(labelText: 'Link'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                updateDocument(
                  docId,
                  titleController.text,
                  descriptionController.text,
                  linkController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> addDocument(String title, String description, String link) async {
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('notifications');

  try {
    await collectionRef.add({
      'title': title,
      'description': description,
      'link': link,
      'timestamp': FieldValue.serverTimestamp(), // Optional: to keep track of the time when the notification is added
    });
    print('Document added successfully');
  } catch (e) {
    print('Error adding document: $e');
  }
}

Future<void> deleteDocument(String docId) async {
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('notifications');

  try {
    await collectionRef.doc(docId).delete();
    print('Document deleted successfully');
  } catch (e) {
    print('Error deleting document: $e');
  }
}

Future<void> updateDocument(
    String docId, String title, String description, String link) async {
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('notifications');

  try {
    await collectionRef.doc(docId).update({
      'title': title,
      'description': description,
      'link': link,
    });
    print('Document updated successfully');
  } catch (e) {
    print('Error updating document: $e');
  }
}
