import 'package:blogapp/constants/routes.dart';
import 'package:flutter/material.dart';

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
                onTap: () {
                  Navigator.of(context).pushNamed(blogDetailRoute);
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
