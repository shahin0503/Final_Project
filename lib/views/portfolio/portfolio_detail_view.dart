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
        children: [
          Text('Username: ${user.username}'),
          Text('Email: ${user.email}'),
          Text('Projects: ${user.projects.join(', ')}'),
          Text('Skills: ${user.skills.join(', ')}'),
          Text('Achievements: ${user.achievements.join(', ')}'),
        ],
      ),
    );
  }
}
