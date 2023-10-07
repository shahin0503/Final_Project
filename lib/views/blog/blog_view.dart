import 'dart:convert';
import 'dart:developer';

import 'package:blogapp/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlogView extends StatefulWidget {
  const BlogView({super.key});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  List<Map<String, dynamic>> blogs = [];

  @override
  void initState() {
    super.initState();
    fetchblogs();
  }

  Future<List<Map<String, dynamic>>> fetchblogs() async {
    http.Response response;
    try {
      response = await http.get(Uri.parse("http://10.1.86.163:1337/api/blogs"));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body)["data"];
        if (responseData is List) {
          var blogsList =
              responseData.map((blog) => blog["attributes"]).toList();
          return blogsList.cast<Map<String, dynamic>>();
        } else if (responseData is Map<String, dynamic>) {
          return [responseData["attributes"]].cast<Map<String, dynamic>>();
        } else {
          log('error fetching blogs: ${response.statusCode}');
        }
      }
      log('fetchBlogs response ${response.statusCode}');
      log('Response body: ${response.body}');
      return [];
    } catch (error) {
      log('Error fetching blogs: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchblogs(), // a Future<String> or null
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Press button to start.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            if (!snapshot.hasData || snapshot.data!.isEmpty)
              return Text('No data available.');

            // If the Future is complete, build the list of blogs
            List<Map<String, dynamic>> blogs = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: blogs.length,
                    itemBuilder: (context, index) {
                      var blogData = blogs[index];
                      String title = blogData['title'] as String? ?? 'No Title';
                      String description = blogData['description'] as String? ??
                          'No Description';

                      return GestureDetector(
                        onTap: () async {
                          // Handle item tap if needed
                        },
                        child: Card(
                          elevation: 2,
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Description: $description'),
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
                    // Handle button press if needed
                  },
                  child: const Icon(Icons.person_3_sharp),
                ),
              ],
            );
        }
      },
    );
  }

  // Column(
  //   children: [
  //     Expanded(
  //       child: ListView.builder(
  //         itemCount: blogs.length,
  //         itemBuilder: (context, index) {
  //           var blogData = blogs[index];

  //           String title = blogData['title'] as String? ?? 'No Title';
  //           String description =
  //               blogData['description'] as String? ?? 'No Description';
  //           print(title);
  //           print(description);
  //           return GestureDetector(
  //             onTap: () async {
  //               await fetchblogs();
  //               // Navigator.of(context).pushNamed(blogDetailRoute);
  //             },
  //             child: Card(
  //                 elevation: 2,
  //                 margin: EdgeInsets.all(8),
  //                 child: ListTile(
  //                   title: Text(blogData['title'] ?? 'No Title'),
  //                   subtitle: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text('Description: ${blogData['description']}'),
  //                     ],
  //                   ),
  //                   //             trailing: user.userId == loggedInUser.userId
  //                   // ? PopupMenuButton<String>(
  //                   //     onSelected: (String choice) {
  //                   //       if (choice == 'edit') {
  //                   //         // Handle edit action
  //                   //         // Navigate to edit screen or show edit dialog
  //                   //       } else if (choice == 'delete') {
  //                   //         // Handle delete action
  //                   //         // Delete the item from the list or show delete confirmation dialog
  //                   //       }
  //                   //     },
  //                   //     itemBuilder: (BuildContext context) {
  //                   //       return ['edit', 'delete']
  //                   //           .map((String choice) => PopupMenuItem<String>(
  //                   //                 value: choice,
  //                   //                 child: Text(choice),
  //                   //               ))
  //                   //           .toList();
  //                   //     },
  //                   //   )
  //                   // : null, // If user is not the creator, don't show the popup menu
  //                 )),
  //           );
  //         },
  //       ),
  //     ),
  //     FloatingActionButton(
  //       onPressed: () async {
  //         await Navigator.of(context).pushNamed(addBlogRoute);
  //         // _fetchUserData();
  //       },
  //       child: const Icon(Icons.person_3_sharp),
  //     ),
  //   ],
  // );
}
