class Blog {
  String user_email;
  String title;
  String description;
  int id;
  Blog({
    required this.user_email,
    required this.title,
    required this.description,
    required this.id,
  });

  factory Blog.fromMap(Map<String, dynamic> data) {
    return Blog(
        user_email: data['user_email'] ?? '',
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        id: data['id'] ?? 0);
  }

  String getPreview() {
    // Adjust the preview length according to your needs
    const int maxLength = 200;
    if (description.length <= maxLength) {
      return description;
    } else {
      return '${description.substring(0, maxLength)}...';
    }
  }
}
