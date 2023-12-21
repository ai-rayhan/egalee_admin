import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestAcceptScreen extends StatefulWidget {


  const RequestAcceptScreen({super.key, });

  @override
  _RequestAcceptScreenState createState() => _RequestAcceptScreenState();
}

class _RequestAcceptScreenState extends State<RequestAcceptScreen> {
  var _firestore=FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

  }

Future<List<DocumentSnapshot>> getRequestDetails() async {
  QuerySnapshot querySnapshot = await _firestore
    .collection('admin')
    .doc('allunlockCourseRequests')
    .collection('unlockCourseRequests')
    .get();

  return querySnapshot.docs;
}


 Future<void> acceptRequest(String requestId, String userId) async {
    // Retrieve request details
    DocumentSnapshot requestSnapshot = await _firestore
        .collection('admin')
        .doc('allunlockCourseRequests')
        .collection('unlockCourseRequests')
        .doc(requestId)
        .get();

    if (requestSnapshot.exists) {
      Map<String, dynamic> requestData =
          requestSnapshot.data() as Map<String, dynamic>;

      // Save the course in the user's 'courses' collection
      String courseId = requestData['courseId'];
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('courses')
          .add({
        'courseName': requestData['courseName'],
        'courseCategoryName': requestData['courseCategoryName'],
        'courseSubCategoryName': requestData['courseSubCategoryName'],
        'fee': requestData['fee'],
        'courseId': requestData['courseId'],
      });

      // Remove the request from 'unlockCourseRequests' collection
      await _firestore
          .collection('admin')
          .doc('allunlockCourseRequests')
          .collection('unlockCourseRequests')
          .doc(requestId)
          .delete();

      // Remove the request from the user's 'orders' collection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(requestId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Accept Screen'),
      ),
      body:FutureBuilder<List<DocumentSnapshot>>(
  future: getRequestDetails(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text('No requests found'));
    } else {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          DocumentSnapshot requestData = snapshot.data![index];
          Map<String, dynamic> requestDataMap =
              requestData.data() as Map<String, dynamic>;

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Course Name: ${requestDataMap['courseName']}'),
              subtitle: Text('Category: ${requestDataMap['courseCategoryName']}'),
              // Display other details as needed
              trailing: ElevatedButton(
                onPressed: () async {
                  await acceptRequest(requestData.id, requestDataMap['userId']);
                },
                child: Text('Accept'),
              ),
            ),
          );
        },
      );
    }
  },
),

    );
  }
}
