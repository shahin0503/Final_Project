class User {
  String username;
  String email;
  List<String> projects;
  List<String> skills;
  List<String> achievements;

  User({
    required this.username,
    required this.email,
    required this.projects,
    required this.skills,
    required this.achievements,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      username: data['username'] ?? '',
      email: data['user_email'] ?? '',
      projects: List.from(data['projects'] ?? []),
      skills: List.from(data['skills'] ?? []),
      achievements: List.from(data['achievements'] ?? []),
    );
  }
}
