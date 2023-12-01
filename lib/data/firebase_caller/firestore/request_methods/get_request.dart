import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../firestore_caller_returnObject.dart';
abstract class GetRequest {
  static Future<FireStoreCallerReturnObject> execute(
      CollectionReference collectionReference,
      {String? token,
      String? docID}) async {
    try {
      QuerySnapshot querySnapshot = await collectionReference.get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      List<Map<String, dynamic>> dataList = [];
      documents.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        dataList.add(data);
      });
      return FireStoreCallerReturnObject(
        errorMessage: '',
        returnValue: dataList,
        success: true,
      );
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return FireStoreCallerReturnObject(
          errorMessage: 'permission-denied',
          returnValue: '',
          success: true,
        );
      } else {
        debugPrint(e.toString());
        return FireStoreCallerReturnObject(
          errorMessage: 'an unknown error occur from hostside',
          returnValue: '',
          success: true,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return FireStoreCallerReturnObject(
        errorMessage: 'an unknown error occur from client side',
        returnValue: '',
        success: true,
      );
    }
  }
}
