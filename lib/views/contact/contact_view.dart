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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late String name, email, title, description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: TextEditingController(text: userName),
                  decoration: const InputDecoration(labelText: 'User name'),
                  enabled: false,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: TextEditingController(text: userEmail),
                  decoration: const InputDecoration(labelText: 'Email'),
                  enabled: false,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) => title = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) => description = value!,
                  keyboardType: TextInputType.multiline,
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
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Form submitted successfully!'),
                          duration: Duration(seconds: 2),
                        ));
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Error submitting form. Please try again.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
