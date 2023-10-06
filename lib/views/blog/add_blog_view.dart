import 'dart:convert';

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

  Future<void> _submitBlog() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      Map<String, dynamic> blogData = {
        'user_email': 'user@example.com', // Replace with the user's email
        'title': blogTitle,
        'description': blogDescription,
      };

  print('submitBlog');
      String jsonData = jsonEncode({"data": blogData});
      print('jsondata $jsonData');
      // Send data to your Strapi API endpoint
      try {
        final response = await http.post(
        Uri.parse('http://192.168.0.109:1337/api/blogs'),
        headers: {
          'Content-Type': 'application/json',
        },
      body: json.encode({"data": blogData}),
        
      );

      if (response.statusCode == 201) {
        // Blog post created successfully
        // Navigator.of(context).pop();
        print('blog created');
      } else {
        // Handle error, show snackbar or dialog to inform the user
        print(
            'Failed to create blog post. Status code: ${response.statusCode}');
      }
      } catch (e) {
  print('Error fetching blogs: $e');
        
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
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  _submitBlog();

                  // Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.done_all_sharp))
        ],
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter blog title';
                  }
                  return null;
                },
                onSaved: (value) => blogTitle = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter blog description';
                  }
                  return null;
                },
                onSaved: (value) => blogDescription = value!,
              )
            ],
          )),
    );
  }
}
