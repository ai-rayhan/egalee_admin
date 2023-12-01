import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firestore_caller_returnObject.dart';


abstract class PostRequest {
  static Future<FireStoreCallerReturnObject> execute(
      CollectionReference collectionReference, Map<String, dynamic> data,
      {String? token, String? docID}) async {
    try {
      await collectionReference.add(data);
      return FireStoreCallerReturnObject(
        errorMessage: '',
        returnValue: data,
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
        log(e.toString());
        return FireStoreCallerReturnObject(
          errorMessage: 'an unknown error occur from hostside',
          returnValue: '',
          success: true,
        );
      }
    } catch (e) {
      log(e.toString());
      return FireStoreCallerReturnObject(
        errorMessage: 'an unknown error occur from client side',
        returnValue: '',
        success: true,
      );
    }
  }
}
