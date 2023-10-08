import 'package:blogapp/services/blogs/blog_view_service.dart';
import 'package:flutter/material.dart';

class BlogDetailView extends StatelessWidget {
  const BlogDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Blog blog = ModalRoute.of(context)!.settings.arguments as Blog;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
            child: TextFormField(
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  labelText: 'Title',
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          width: 2,
                          color: Color.fromARGB(255, 187, 212, 209)))),
              controller: TextEditingController(
                  text: blog.title), // Set the text from the state
              enabled: false, // Disable editing of email field
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
            child: TextFormField(
              maxLines: null,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  labelText: 'Description',
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          width: 2,
                          color: Color.fromARGB(255, 187, 212, 209)))),
              controller: TextEditingController(
                  text: blog.description), // Set the text from the state
              enabled: false, // Disable editing of email field
            ),
          ),
        ],
      ),
    );
  }
}
