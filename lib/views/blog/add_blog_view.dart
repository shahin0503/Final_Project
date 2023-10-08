import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBlogView extends StatefulWidget {
  const AddBlogView({super.key});

  @override
  State<AddBlogView> createState() => _AddBlogViewState();
}

class _AddBlogViewState extends State<AddBlogView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String blogTitle = '';
  String blogDescription = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userEmail = user.email ?? '';
      });
    }
  }

  Future<void> _submitBlog() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      Map<String, dynamic> blogData = {
        'user_email': userEmail, // Replace with the user's email
        'title': blogTitle,
        'description': blogDescription,
      };

      log('submitBlog');
      String jsonData = jsonEncode({"data": blogData});
      log('jsondata $jsonData');
      // Send data to your Strapi API endpoint
      try {
        final response = await http.post(
          Uri.parse('http://192.168.173.222:1337/api/blogs'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({"data": blogData}),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Blog post created successfully
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Blog added successfully!'),
              duration: Duration(
                  seconds:
                      2), // Duration for which the snackbar will be visible
            ),
          );
          log('blog created');
        } else {
          // Handle error, show snackbar or dialog to inform the user
          log(
              'Failed to create blog post. Status code: ${response.statusCode}');
        }
      } catch (e) {
        log('Error fetching blogs: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Blog'),
        actions: [
          IconButton(
              onPressed: () {
                _submitBlog();
              },
              icon: const Icon(Icons.done_all_sharp))
        ],
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
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
                    if (value!.isEmpty) {
                      return 'Please enter blog title';
                    }
                    return null;
                  },
                  onSaved: (value) => blogTitle = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: null,
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
                    if (value!.isEmpty) {
                      return 'Please enter blog description';
                    }
                    return null;
                  },
                  onSaved: (value) => blogDescription = value!,
                ),
              )
            ],
          )),
    );
  }
}
