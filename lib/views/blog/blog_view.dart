import 'dart:convert';
import 'dart:developer';

import 'package:blogapp/constants/routes.dart';
import 'package:blogapp/services/blogs/blog_view_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlogView extends StatefulWidget {
  const BlogView({super.key});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  List<Blog> blogs = [];
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    fetchblogs();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userEmail = user.email ?? '';
      });
    }
  }

  Future<void> fetchblogs() async {
    http.Response response;
    try {
      response =
          await http.get(Uri.parse("http://192.168.173.222:1337/api/blogs"));
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body)["data"];
        log('responseData $responseData');
        List<Blog> fetchedBlogs = responseData
            .map<Blog>((blog) => Blog.fromMap({
                  'id': blog['id'],
                  'user_email': blog['attributes']['user_email'],
                  'title': blog['attributes']['title'],
                  'description': blog['attributes']['description'],
                }))
            .toList();
        setState(() {
          blogs = fetchedBlogs;
        });
      }
      log('fetchBlogs response ${response.statusCode}');
      log('Response body: ${response.body}');
      //  setState(() {
      //      blogs = blogList;
      //    });
    } catch (error) {
      log('Error fetching blogs: $error');
    }
  }

  Future<void> deleteBlog(id) async {
    http.Response response;
    try {
      response = await http
          .delete(
            Uri.parse("http://192.168.173.222:1337/api/blogs/$id"));
      if (response.statusCode == 200) {
        log('deleteBlog $id deleted');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Blog deleted successfully!'),
          duration: Duration(seconds: 2), // Duration for which the snackbar will be visible
        ),
      );
      fetchblogs();
      }
    } catch (error) {
      log('Error fetching blogs: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: blogs.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Blog blog = blogs[index];
    
                return GestureDetector(
                  onTap: () async {
                    Navigator.of(context)
                        .pushNamed(blogDetailRoute, arguments: blog);
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(blog.title, style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(blog.getPreview(), style: TextStyle(
                            fontSize: 14,
                          ),),
                        ],
                      ),
                      trailing: blog.user_email == userEmail
                          ? PopupMenuButton<String>(
                              onSelected: (String choice) async {
                                if (choice == 'edit') {
                                  await Navigator.of(context).pushNamed(
                                    updateBlogRoute,
                                    arguments: {'blog': blog},
                                  );
                                  fetchblogs();
                                } else if (choice == 'delete') {
                                  await deleteBlog(blog.id);
                                  fetchblogs();
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return ['edit', 'delete']
                                    .map((String choice) => PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice),
                                        ))
                                    .toList();
                              },
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
           
        ],
        
      ),
      floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed(addBlogRoute);
              fetchblogs();
              // Handle button press if needed
            },
            child: const Icon(Icons.add),
          ),
    );
  }
}
