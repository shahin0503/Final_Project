import 'package:flutter/material.dart';

class AddBlogView extends StatefulWidget {
  const AddBlogView({super.key});

  @override
  State<AddBlogView> createState() => _AddBlogViewState();
}

class _AddBlogViewState extends State<AddBlogView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String blogTitle = '';
  String blogDescription = '';

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

                  Navigator.of(context).pop();
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
