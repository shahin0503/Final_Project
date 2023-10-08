import 'dart:convert';

import 'package:blogapp/services/blogs/blog_view_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateBlogView extends StatefulWidget {
  const UpdateBlogView({super.key});

  @override
  State<UpdateBlogView> createState() => _UpdateBlogViewState();
}

class _UpdateBlogViewState extends State<UpdateBlogView> {
  String blogTitle = '';
  String blogDescription = '';
  int id = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _updateBlog() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      Map<String, dynamic> blogData = {
        'title': blogTitle,
        'description': blogDescription,
        'id': id
      };

      String jsonData = jsonEncode({"data": blogData});
      print('jsondata $jsonData');
      // Send data to your Strapi API endpoint
      try {
        final response = await http.put(
          Uri.parse('http://192.168.173.222:1337/api/blogs/$id'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({"data": blogData}),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Blog post created successfully
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Blog updated successfully!'),
              duration: Duration(
                  seconds:
                      2), // Duration for which the snackbar will be visible
            ),
          );
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
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    Blog? blog = arguments?['blog'] as Blog?;

    titleController.text = blog!.title;
    descController.text = blog.description;
    id = blog.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Blog'),
        actions: [
          IconButton(
              onPressed: () {
                _updateBlog();
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
                  controller: titleController,
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
                  controller: descController,
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
