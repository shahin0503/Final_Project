import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _contactusCollection =
      FirebaseFirestore.instance.collection('contactus');

  Future<void> addContactFormData(
    String userUID,
    String userName,
    String userEmail,
    String title,
    String description,
  ) async {
    try {
      await _contactusCollection.add({
        'user_uid': userUID,
        'user_name': userName,
        'user_email': userEmail,
        'title': title,
        'description': description,
      });
    } catch (e) {
      // Handle errors, if any
      print('Error adding user data: $e');
    }
  }

  // You can define more functions for different Firestore operations here
}
