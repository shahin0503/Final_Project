import 'package:blogapp/services/users/portfolio_view_service.dart';
import 'package:flutter/material.dart';

class PortfolioDetailView extends StatelessWidget {
  const PortfolioDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;
 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
            child: TextFormField(
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  labelText: 'User Name',
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          width: 2,
                          color: Color.fromARGB(255, 187, 212, 209)))),
              controller: TextEditingController(
                  text: user.username), // Set the text from the state
              enabled: false, // Disable editing of email field
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
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
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          width: 2,
                          color: Color.fromARGB(255, 187, 212, 209)))),
              controller: TextEditingController(
                  text: user.email), // Set the text from the state
              enabled: false, // Disable editing of email field
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Skills',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Wrap(
            children: user.skills.map((skill) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Chip(
                  label: Text(skill),
                ),
              );
            }).toList(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Projects',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: user.projects.length,
            itemBuilder: (context, index) {
              // Split the project string into title and description
              List<String> projectParts = user.projects[index].split(':');
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
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Achievements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Wrap(
            children: user.achievements.map((achievement) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Chip(
                  label: Text(achievement),
                ),
              );
            }).toList(),
          ),
        ],
        // children: [
        //   Text('Username: ${user.username}'),
        //   Text('Email: ${user.email}'),
        //   Text('Projects: ${user.projects.join(', ')}'),
        //   Text('Skills: ${user.skills.join(', ')}'),
        //   Text('Achievements: ${user.achievements.join(', ')}'),
        // ],
      ),
    );
  }
}
