import 'package:blogapp/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class BlogView extends StatefulWidget {
  const BlogView({super.key});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  List<String> blogs = [
    'title',
    'fdfd',
    'dfdfd',
  ];

   fetchblogs() async {
  //   print('fetchBlogs called');
  // // The URL of the users collection type endpoint
  // // var url = Uri.parse('http://localhost:1337/api/blogs');
  // // // Make a GET request and store the response
  // // var response = await http.get(url);
  // // print('response $response');
  // // // Print the status code and the body of the response
  // // print('Response status: ${response.statusCode}');
  // // print('Response body: ${response.body}');

  //     http.Response response = await http.get(Uri.parse("http://localhost:1337/api/blogs"));
  //     print('fetchBlogs response $response');
  http.Response response;
try {
  response = await http.get(Uri.parse("http://192.168.0.109:1337/api/blogs"));
  print('fetchBlogs response ${response.statusCode}');
  print('Response body: ${response.body}');
} catch (error) {
  print('Error fetching blogs: $error');
}

}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              //  blog = blogs[index];
              return GestureDetector(
                onTap: () async {

                 await fetchblogs();
                  // Navigator.of(context).pushNamed(blogDetailRoute);
                },
                child: const Card(
                    elevation: 2,
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text('blogTitle'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title: '),
                          Text('Description: '),
                        ],
                      ),
                      //             trailing: user.userId == loggedInUser.userId
                      // ? PopupMenuButton<String>(
                      //     onSelected: (String choice) {
                      //       if (choice == 'edit') {
                      //         // Handle edit action
                      //         // Navigate to edit screen or show edit dialog
                      //       } else if (choice == 'delete') {
                      //         // Handle delete action
                      //         // Delete the item from the list or show delete confirmation dialog
                      //       }
                      //     },
                      //     itemBuilder: (BuildContext context) {
                      //       return ['edit', 'delete']
                      //           .map((String choice) => PopupMenuItem<String>(
                      //                 value: choice,
                      //                 child: Text(choice),
                      //               ))
                      //           .toList();
                      //     },
                      //   )
                      // : null, // If user is not the creator, don't show the popup menu
                    )),
              );
            },
          ),
        ),
        FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed(addBlogRoute);
            // _fetchUserData();
          },
          child: const Icon(Icons.person_3_sharp),
        ),
      ],
    );
  }
}
