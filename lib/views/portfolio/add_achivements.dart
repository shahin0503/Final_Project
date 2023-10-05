import 'package:flutter/material.dart';

class AddAchievementsBottomSheet extends StatefulWidget {
  final void Function(String achievement) addAchievement;

  const AddAchievementsBottomSheet({super.key, required this.addAchievement});

  @override
  State<AddAchievementsBottomSheet> createState() =>
      _AddAchievementsBottomSheetState();
}

class _AddAchievementsBottomSheetState
    extends State<AddAchievementsBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String achievement = '';
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
            onSaved: (value) => achievement = value!,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                widget.addAchievement(achievement);
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
