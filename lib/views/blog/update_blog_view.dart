import 'dart:convert';
import 'dart:developer';

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
          Uri.parse('http://192.168.1.105:1337/api/blogs/$id'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({"data": blogData}),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Blog post created successfully
          Navigator.of(context).pop();
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
    Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
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
              TextFormField(
                controller: titleController,
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
                controller: descController,
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

