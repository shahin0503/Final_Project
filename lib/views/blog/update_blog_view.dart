import 'package:flutter/material.dart';

class UpdateBlogView extends StatefulWidget {
  const UpdateBlogView({super.key});

  @override
  State<UpdateBlogView> createState() => _UpdateBlogViewState();
}

class _UpdateBlogViewState extends State<UpdateBlogView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Blog')),
    );
  }
}
