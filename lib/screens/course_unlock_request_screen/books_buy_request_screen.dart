import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookBuyRequestScreen extends StatelessWidget {
  const BookBuyRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books Buy Requests'),
      ),
      body: Center(
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('admin')
              .doc('allunlockCourseRequests')
              .collection('bookUnlockRequests')
              .orderBy("timestamp")
              .get(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.docs.isEmpty) {
              return Text('No documents found');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var document = snapshot.data!.docs[index];
                  var data = document.data();
                  return Card(
                    child: ListTile(
                      title: Text('Title: ${data['title']}'),
                      subtitle:
                          Text('Writer:${data['writer']}\nRequest From: ${data['senderNo']}\nTransection ID: ${data['transactionNo']}'),
                      trailing: SizedBox(
                        width: 90,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: ()async{
                             await deleteRequest(document.id, data['userId'],
                                    data['bookId'],);
                                Navigator.pop(context);
                            }, child: Icon(Icons.delete,color: Colors.red,)),
                            SizedBox(width: 10,),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: IconButton(
                                onPressed: () async {
                                  await approveRequest(document.id, data['userId'],
                                      data['bookId'], data);
                                  Navigator.pop(context);
                                  Navigator.push<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const BookBuyRequestScreen(),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.check_circle,size: 30,color: Colors.green,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

var _firestore = FirebaseFirestore.instance;
var _auth = FirebaseAuth.instance;
approveRequest(String requestId, String userId, String bookId,
    Map<String, dynamic> bookDetails) async {
  try {
    // Get reference to the specific request in admin's collection
    DocumentReference requestRef = _firestore
        .collection('admin')
        .doc('allunlockCourseRequests')
        .collection('bookUnlockRequests')
        .doc(requestId);
    DocumentReference userOrderref = _firestore
        .collection('users')
        .doc(userId)
        .collection('orderbooks')
        .doc(bookId);
    // Get the request details
    DocumentSnapshot requestSnapshot = await requestRef.get();
    if (requestSnapshot.exists) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('mybooks')
          .doc(bookId)
          .set(bookDetails);

      await requestRef.delete();
      await userOrderref.delete();
      return true;
    } else {
      // Handle if the request doesn't exist or already processed
      return false;
    }
  } catch (e) {
    print(e);
    // Handle errors
    return false;
  }
}
deleteRequest(String requestId, String userId, String bookId) async {
  try {
    // Get reference to the specific request in admin's collection
    DocumentReference requestRef = _firestore
        .collection('admin')
        .doc('allunlockCourseRequests')
        .collection('bookUnlockRequests')
        .doc(requestId);
    DocumentReference userOrderref = _firestore
        .collection('users')
        .doc(userId)
        .collection('orderbooks')
        .doc(bookId);
    // Get the request details
  await requestRef.delete();
  await userOrderref.delete();
  return true;
  } catch (e) {
    print(e);
    // Handle errors
    return false;
  }
}
