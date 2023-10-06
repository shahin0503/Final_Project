import 'package:blogapp/services/users/firestore_service.dart';
import 'package:blogapp/views/portfolio/add_achivements.dart';
import 'package:blogapp/views/portfolio/add_projects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_tag_editor/tag_editor.dart';

class MyProfile extends StatefulWidget {
  final FirestoreService _firestoreService = FirestoreService();

  MyProfile({
    super.key,
  });

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final TextEditingController userNameController = TextEditingController();

  String userUID = '';
  String userEmail = ''; // Store user's email here
  String userName = '';
  List<String> skills = [];
  List<String> projects = [];
  List<String> achievements = [];

  @override
  void initState() {
    super.initState();

    // Fetch the user's email and update the state
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ??
            ''; // Use an empty string as a default value if email is null
        userUID = user.uid;
      });
      checkIfUserExist().then(
        (_) {
          setState(() {
            userNameController.text = userName;
          });
        },
      );
    }
  }

  Future<void> checkIfUserExist() async {
    try {
      // Fetch data from the Firestore collection 'portfolio' where user_email matches
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('portfolio')
          .where('user_email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // User exists in the portfolio collection, populate the fields
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          userName = userData['user_name'];
          skills = List.from(userData['skills']);
          projects = List.from(userData['projects']);
          achievements = List.from(userData['achievements']);
        });
      } else {}
    } catch (e) {
      // Handle errors, if any
      print('Error fetching user data: $e');
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () {
                widget._firestoreService.addUserData(userUID, userName,
                    userEmail, projects, achievements, skills);
              },
              icon: Icon(Icons.done_all_sharp))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'User Name',
              ),
              controller: userNameController,
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              controller: TextEditingController(
                  text: userEmail), // Set the text from the state
              enabled: false, // Disable editing of email field
            ),
            TagEditor(
              length: skills.length,
              delimiters: const [' ', ','],
              hasAddButton: true,
              textInputAction: TextInputAction.next,
              autofocus: false,
              maxLines: 1,
              inputDecoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                labelText: 'Add Skills...',
                labelStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  backgroundColor: Color(0x65dffd02),
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              onTagChanged: (newValue) {
                setState(() {
                  skills.add(newValue);
                });
              },
              tagBuilder: (context, index) => _Chip(
                index: index,
                label: skills[index],
                onDeleted: (int index) {
                  setState(() {
                    skills.removeAt(index);
                  });
                },
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildListTile(
                      'Projects', projects, _openProjectsBottomSheet),
                  _buildListTile('Achievements', achievements,
                      _openAchievementsBottomSheet),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(
      String title, List<String> items, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      trailing:
          const Icon(Icons.arrow_forward), // Add a trailing icon for navigation
    );
  }

  ListView _buildProjectsListView(List<String> projects) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Project ${index + 1}: ${projects[index]}'),
          // Add other project-related information here
        );
      },
    );
  }

  ListView _buildAchievementsListView(List<String> achievements) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Achievement ${index + 1}: ${achievements[index]}'),
          // Add other achievement-related information here
        );
      },
    );
  }

  void _openProjectsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            _buildProjectsListView(projects),
            AddProjectsBottomSheet(
              addProject: _addProject,
            ),
          ],
        );
      },
    );
  }

  void _openAchievementsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            _buildAchievementsListView(achievements),
            AddAchievementsBottomSheet(
              addAchievement: _addAchievement,
            ),
          ],
        );
      },
    );
  }

  void _addProject(String title, String description) {
    setState(() {
      // Assuming projects is a list in your State
      projects.add('$title: $description');
    });
  }

  void _addAchievement(String achievement) {
    setState(() {
      achievements.add(achievement);
    });
  }
}

class _Chip extends StatelessWidget {
  final int index;
  final String label;
  final Function(int) onDeleted;

  const _Chip({
    Key? key,
    required this.index,
    required this.label,
    required this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
