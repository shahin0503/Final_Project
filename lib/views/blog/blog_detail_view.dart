import 'package:flutter/material.dart';

class BlogDetailView extends StatelessWidget {
  const BlogDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Details'),
      ),
      body: Column(
        children: [
          Text('Title: '),
        ],
      ),
    );
  }
}
