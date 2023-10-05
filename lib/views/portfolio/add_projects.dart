import 'package:flutter/material.dart';

class AddProjectsBottomSheet extends StatefulWidget {
  final void Function(String title, String description) addProject;

  const AddProjectsBottomSheet({super.key, required this.addProject});

  @override
  State<AddProjectsBottomSheet> createState() => _AddProjectsBottomSheetState();
}

class _AddProjectsBottomSheetState extends State<AddProjectsBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Form(
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
                widget.addProject(_title, _description);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
