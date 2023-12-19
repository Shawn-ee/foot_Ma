import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  // This would be replaced with your actual data fetching logic
  List<Map<String, dynamic>> forumPosts = [
    {"title": "Welcome to the Forum", "content": "Feel free to share your thoughts!"},
    // Add more sample posts here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forum"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: forumPosts.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(forumPosts[index]['title']),
              subtitle: Text(forumPosts[index]['content']),
              onTap: () {
                // Navigate to post detail page

              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Create Post Page
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
