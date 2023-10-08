import 'dart:developer';

import 'package:blogapp/constants/routes.dart';
import 'package:blogapp/services/users/portfolio_view_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PortfolioView extends StatefulWidget {
  const PortfolioView({super.key});

  @override
  State<PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Fetch data from the Firestore collection 'portfolio'
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('portfolio').get();

      // Convert the retrieved data to a list of User objects
      List<User> fetchedUsers = querySnapshot.docs
          .map((DocumentSnapshot document) =>
              User.fromMap(document.data() as Map<String, dynamic>))
          .toList();

      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      log('Error fetching user data: $e');
    }
  }



  Widget _buildCategoryWithChips(String title, List<String> projects) {
    List<String> projectTitles = projects.map((project) {
    List<String> parts = project.split(':');
    return parts.isNotEmpty ? parts[0] : project;
  }).toList();
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Wrap(
            spacing: 4,
            children: projectTitles
                .map(
                  (item) => Chip(
                    label: Text(item),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ListView.builder(
            itemCount: users.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              User user = users[index];
              return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(portfolioDetailRoute, arguments: user);
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8),
                    child: ClipRect(
                      child: ListTile(
                        title: Text(
                          user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRect(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      user.email,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  _buildCategoryWithChips(
                                      'Projects: ', user.projects),
                                  _buildCategoryWithChips(
                                      'Skills:', user.skills),
                                  _buildCategoryWithChips(
                                      'Achievements:', user.achievements),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(profileRoute);
          _fetchUserData();
        },
        child: const Icon(Icons.person_3_sharp),
      ),
    );
  }
}
