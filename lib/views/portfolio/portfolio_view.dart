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
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
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
                  child: ListTile(
                    title: Text(user.username),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user.email}'),
                        Text('Projects: ${user.projects.join(', ')}'),
                        Text('Skills: ${user.skills.join(', ')}'),
                        Text('Achievements: ${user.achievements.join(', ')}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed(profileRoute);
            _fetchUserData();
          },
          child: const Icon(Icons.person_3_sharp),
        ),
      ],
    );
  }
}
