import 'package:flutter/material.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({super.key});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Project'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Project Title'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter project title';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter project description';
                }
                return null;
              },
              onSaved: (value) => _description = value!,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                  }
                },
                child: const Text('save'))
          ],
        ),
      ),
    );
  }
}
