import 'package:blogapp/services/contact_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class ContactView extends StatefulWidget {
  final FirestoreService _firestoreService = FirestoreService();

  ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  String userUID = '';
  String userEmail = ''; // Store user's email here
  String userName = '';

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ??
            ''; // Use an empty string as a default value if email is null
        userUID = user.uid;
      });
      checkIfUserExist();
    }
  }

  Future<void> checkIfUserExist() async {
    try {
      // Fetch data from the Firestore collection 'portfolio' where user_email matches
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('portfolio')
          .where('user_email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // User exists in the portfolio collection, populate the fields
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          userName = userData['user_name'];
        });
      } else {}
    } catch (e) {
      // Handle errors, if any
      print('Error fetching user data: $e');
    }
  }

  final _formKey = GlobalKey<FormState>();

  late String name, email, title, description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                child: TextFormField(
                  controller: TextEditingController(text: userName),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      labelText: 'User Name',
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 187, 212, 209)))),
                  enabled: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: TextEditingController(text: userEmail),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 187, 212, 209)))),
                  enabled: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      labelText: 'Title',
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.teal,
                            width: 12,
                          ))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) => title = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      labelText: 'Description',
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.teal,
                            width: 12,
                          ))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) => description = value!,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget._firestoreService
                        .addContactFormData(
                            userUID, userName, userEmail, title, description)
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Message send successfully!'),
                        duration: Duration(seconds: 2),
                      ));
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Error sending message. Please try again.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    });
                  }
                },
                style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(200, 50)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ))),
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
