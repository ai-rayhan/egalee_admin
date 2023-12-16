 import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> saveNewNotification(
      String userUID, String title, String subtitle) async {
    try {
      final userDocRef = _firestore.collection('users').doc(userUID);
      final notificationsCollectionRef = userDocRef.collection('notifications');

      final newNotificationRef =
          notificationsCollectionRef.doc(); // Generate a unique document ID
      final timestamp = FieldValue.serverTimestamp(); // Server timestamp

      await newNotificationRef.set({
        'title': title,
        'subtitle': subtitle,
        'timestamp': timestamp,
        'seen': false,
      });
     
    } catch (e) {
      print("Error saving notification: $e");
      throw e;
    }
  }