import 'package:flutter/material.dart';

class AddProjectsBottomSheet extends StatefulWidget {
  final void Function(String title, String description) addProject;
  final void Function(String title, String description) onAdd;

  const AddProjectsBottomSheet({super.key, required this.addProject, required this.onAdd});

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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              labelText: 'Project Title',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors.teal,
                                    width: 12,
                                  ))),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter project title';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            child: TextFormField(
              decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              labelText: 'Description',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors.teal,
                                    width: 12,
                                  ))),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter project description';
                }
                return null;
              },
              onSaved: (value) => _description = value!,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                widget.onAdd(_title, _description);
                // addProject(_title, _description);
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
