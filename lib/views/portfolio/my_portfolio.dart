import 'package:blogapp/services/users/firestore_service.dart';
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
      print('Error fetching user data: $e');
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  void _addProject(String title, String description) {
    setState(() {
      projects.add('$title: $description');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio'),
        actions: [
          IconButton(
              onPressed: () {
                widget._firestoreService.addUserData(userUID, userName,
                    userEmail, projects, achievements, skills);
                    ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Portfolio updated successfully!'),
                ),
              );
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.done_all_sharp))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      labelText: 'User Name',
                      labelStyle:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.teal,
                            width: 12,
                          ))),
                  controller: userNameController,
                  onChanged: (value) {
                    setState(() {
                      userName = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.teal,
                            width: 12,
                          ))),
                  controller: TextEditingController(
                      text: userEmail), // Set the text from the state
                  enabled: false, // Disable editing of email field
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Skills: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
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
                    fontWeight: FontWeight.bold,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Projects: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 132, 192, 186),
                          borderRadius: BorderRadius.circular(60)),
                      child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return AddProjectsBottomSheet(
                                  addProject: _addProject,
                                  onAdd: _addProject,
                                );
                              },
                            );
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.teal)),
                          icon: const Icon(Icons.add)),
                    )
                  ],
                ),
              ),
              _buildProjectsListView(projects),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Achievements: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              TagEditor(
                length: achievements.length,
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
                  labelText: 'Add achievement...',
                  labelStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Color(0x65dffd02),
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                onTagChanged: (newValue) {
                  setState(() {
                    achievements.add(newValue);
                  });
                },
                tagBuilder: (context, index) => _Chip(
                  index: index,
                  label: achievements[index],
                  onDeleted: (int index) {
                    setState(() {
                      achievements.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView _buildProjectsListView(List<String> projects) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: projects.length,
    itemBuilder: (context, index) {
      // Split the project string into title and description
      List<String> projectParts = projects[index].split(':');
      String title = projectParts[0].trim();
      String description = projectParts[1].trim();

      return Card(
        elevation: 4,
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ), // Display title as the title of the ListTile
          subtitle: Text(description),
          trailing: GestureDetector(
            onTap: () {
              // Handle delete operation on tap of the delete icon
              setState(() {
                projects.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Project "$title" deleted'),
                ),
              );
            },
            child: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ),
      );
    },
  );
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
