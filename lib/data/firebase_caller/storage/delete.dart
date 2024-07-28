import 'package:firebase_storage/firebase_storage.dart';

class FiledeleteUtils {
  static Future<void> deleteImageFromFirebaseStorage(String? url) async {
    // Create a Firebase Storage instance
    FirebaseStorage storage = FirebaseStorage.instance;

    // Get the reference to the image using its URL
   if(url==null||url==''){}
   else{
    try {
    Reference ref = storage.refFromURL(url);
    print('deleting file path:$url');
      // Delete the file from Firebase Storage
      await ref.delete();
      print('deleted');
    } catch (e) {
      print('Error deleting image: $e');
      // Handle any errors that occur during deletion
    }}
  }
}
