import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _portfolioCollection =
      FirebaseFirestore.instance.collection('portfolio');

  Future<void> addUserData(
      String userUID,
      String userEmail,
      List<String> projects,
      List<String> achievements,
      List<String> skills) async {
    try {
      await _portfolioCollection.doc(userUID).set({
        'user_uid': userUID,
        'user_email': userEmail,
        'projects': projects,
        'achievements': achievements,
        'skills': skills,
      });
    } catch (e) {
      // Handle errors, if any
      print('Error adding user data: $e');
    }
  }

  // You can define more functions for different Firestore operations here
}
